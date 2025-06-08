import boto3
from strands import Agent
from strands.models import BedrockModel
import logging
import json
import strip_markdown
from dto.generate_test_env_request import GenerateTestEnvRequest

# Carregar o arquivo de dependências
def load_dependencies(file_path):
    with open(file_path, "r") as file:
        return json.load(file)

# Filtrar apenas as aplicações que possuem dependências
def filter_dependent_apps(apps):
    return [app for app in apps if app["dependencies"]]

# Gerar um prompt para o ChatBedrock criar o Terraform
def generate_terraform_prompt(app_name, apps):
    services_str = "\n".join([
        f"- {app['name']} (Repo: {app['repo']}) depende de {', '.join(app['dependencies'])}"
        for app in apps
    ])
    
    prompt = f"""
    Gere um arquivo Terraform para provisionar os seguintes microsserviços de forma efêmera para a aplicação com o nome {app_name}:

    {services_str}

    O Terraform deve conter:
    - Recursos para cada serviço listado acima.
    - Dependências entre os serviços.
    - Provisionamento temporário (tempo de vida curto).
    """
    
    return prompt

# Usar ChatBedrock para gerar o Terraform
def generate_terraform_code(prompt):
    chat = ChatBedrock(model="anthropic.claude-v2", region="us-west-2")
    response = chat.invoke(prompt)
    return response

def process(request: GenerateTestEnvRequest) -> str:
    file_path = "./resources/cmdb-output.json"  # Arquivo JSON com dependências
    data = load_dependencies(file_path)
        
    dependent_apps = filter_dependent_apps(data["apps"])
        
    if not dependent_apps:
        print("Nenhuma aplicação depende de outra. Nada a provisionar.")
        return

    
    prompt = generate_terraform_prompt(request.app_name, dependent_apps)

    
    session = boto3.Session(
        aws_access_key_id="ASIAYJ3F7NUYVYEDGCHS",
        aws_secret_access_key="o9Z0A7VVyOX7VyztvVZZ8b4Ot8yVJ9NsXLy7zjZk",
        aws_session_token="IQoJb3JpZ2luX2VjELX//////////wEaCXVzLWVhc3QtMSJHMEUCIQDZoNP3pW0ugI5TacQ17f8sRa6qvN/peY7x06HEqxpKjAIgYhgb++NMgDEkNRr1tI+qyvZMT0if8t1sVo3noidrHVQqogIIjf//////////ARACGgw1NzA5MDc2NTEzNzciDJ6xaSGTIUbO2CWe9ir2AekZcBrM3/YriffQZnYOSeypdQQNc5FaZOuMNR8lIAYINs3a4g94ey2Vby6NrvcgP6mTlFyEJzJFikdOG52UDc8HDZjNqF5Acy20BcKETh6kgNTaU3xRs/Ed9W92jw3f4qrCTwBuowjYCEfsdlYT56kmD0vwlRZsmqG6qZWHmLQlEa18yRAje8uQpokq1m1HZxx0P4QZ3J5M+5KhgPgDqATvUqBf5ONsGrVxoDmyvEkzFGJdbwkRMgKFauI4CmlA63ZBKq6giByMGVR+KvbNXce5j6nBSQki4jsvU+Qja79Ibg2SpUWeDHrb94R//LKg/Bk+pf8mtDCI/JXCBjqdAe62bt+xspfZy7+KS8Q1jZpDamVtFcffLBB0AkYZEJFQQCjK7OSeeD2lkucdlcVVM6xMfMBvyn7pMxuePQ9pp4DmFiW8Ij0CyXDaBa3B3jeWpQk6EBFB+vEyrHjiRSejzUus+Q+gYetNatJmSM1fFmFrg5sJ1ofEpYIL9TosGv8Z0+vCJOBG4xd81sBwQwvzOQcTqgK3tv0xs0MYPC8=",
        region_name="us-west-2",
    )
    
    bedrock_model = BedrockModel(
        model_id="us.anthropic.claude-3-7-sonnet-20250219-v1:0",
        boto_session=session,
        temperature=0.4,
        top_p=0.8,
    )

    
    agent = Agent(system_prompt=prompt, model=bedrock_model)
    agent_result = agent("Gere exatamente apenas o código Terraform para provisionar os serviços listados acima. Nada além disso.")

    print(agent_result)

    # Extract textual content from agent_result
    final_agent_response_text = ""
    if hasattr(agent_result, 'response') and isinstance(agent_result.response, str):
        final_agent_response_text = agent_result.response
    elif hasattr(agent_result, 'content') and isinstance(agent_result.content, str):
        final_agent_response_text = agent_result.content
    elif hasattr(agent_result, 'output') and isinstance(agent_result.output, str):
        final_agent_response_text = agent_result.output
    elif isinstance(agent_result, str):
        final_agent_response_text = agent_result
    else:
        try:
            final_agent_response_text = str(agent_result)
            print("DEBUG: Converted agent_result to string.")
        except Exception as e:
            print(f"ERROR: Could not extract text from AgentResult. Error: {e}")
            print("Please inspect the 'agent_result' object to determine the correct attribute.")

    final_agent_response_text = strip_markdown.strip_markdown(final_agent_response_text)

    # Salvar o código Terraform gerado
    with open("./out/generated_terraform.tf", "w") as file:
        file.write(final_agent_response_text)

    print("Arquivo Terraform gerado com sucesso: generated_terraform.tf")
    return final_agent_response_text