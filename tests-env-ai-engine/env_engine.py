import os
import json
from typing import List, Dict, Set
from langchain.prompts import PromptTemplate
from langchain_community.llms import HuggingFaceHub

class DependencyEngine:
    def __init__(self, dependency_file: str, llm_api_key: str):
        self.dependency_file = dependency_file
        # self.llm = HuggingFaceHub(repo_id="google/flan-t5-xl")
        # Load a local model, e.g., google/flan-t5-small (downloaded automatically)
        local_pipe = pipeline("text2text-generation", model="google/flan-t5-small")
        self.llm = HuggingFacePipeline(pipeline=local_pipe)
        self.dependencies, self.repos = self._parse_dependency_file()

    def _parse_dependency_file(self) -> (Dict[str, List[str]], Dict[str, str]):
        """
        Reads the JSON dependency file and returns:
        - dependencies: {app: [dep1, dep2, ...]}
        - repos: {app: repo_url}
        """
        with open(self.dependency_file, 'r') as f:
            data = json.load(f)
        dependencies = {}
        repos = {}
        for app in data["apps"]:
            name = app["name"]
            dependencies[name] = app.get("dependencies", [])
            repos[name] = app.get("repo", "")
        return dependencies, repos

    def _resolve_dependencies(self, app: str, visited: Set[str]=None) -> Set[str]:
        if visited is None:
            visited = set()
        if app not in self.dependencies or app in visited:
            return set()
        visited.add(app)
        for dep in self.dependencies[app]:
            visited.update(self._resolve_dependencies(dep, visited))
        return visited

    def generate_terraform(self, app: str, output_file: str):
        all_apps = self._resolve_dependencies(app)
        all_apps.add(app)
        prompt = PromptTemplate(
            input_variables=["apps"],
            template=(
                "Generate a Terraform configuration to deploy the following applications "
                "in an ephemeral virtual environment: {apps}. "
                "Each application should be deployed as a separate resource. "
                "Use best practices for ephemeral environments."
            )
        )
        apps_str = ', '.join(sorted(all_apps))
        terraform_code = self.llm(prompt.format(apps=apps_str))
        with open(output_file, 'w') as f:
            f.write(terraform_code)
        print(f"Terraform file generated at {output_file}")

# Example usage:
engine = DependencyEngine('../resources/dependencies.json', llm_api_key='sk-...')
# engine.generate_terraform('credit-card', 'output.tf')
