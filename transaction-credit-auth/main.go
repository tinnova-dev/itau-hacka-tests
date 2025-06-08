package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

type TransactionRequest struct {
	Amount float64 `json:"amount"`
}

type RiskResponse struct {
	Status string `json:"status"`
}

type TransactionResponse struct {
	Approved bool   `json:"approved"`
	Message  string `json:"message"`
}

func main() {
	r := chi.NewRouter()

	// Middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Rotas
	r.Post("/transaction", handleTransaction)

	log.Println("Servidor iniciado na porta 8081")
	log.Fatal(http.ListenAndServe(":8081", r))
}

func handleTransaction(w http.ResponseWriter, r *http.Request) {
	var req TransactionRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Erro ao decodificar requisição", http.StatusBadRequest)
		return
	}

	// Chama o serviço de análise de risco
	riskResp, err := callRiskEngine()
	if err != nil {
		http.Error(w, "Erro ao consultar serviço de risco", http.StatusInternalServerError)
		return
	}

	// Processa a resposta
	response := TransactionResponse{
		Approved: riskResp.Status == "ok",
		Message:  "Transação " + riskResp.Status,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func callRiskEngine() (*RiskResponse, error) {
	resp, err := http.Get("http://localhost:8080/risk-analysis")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var riskResp RiskResponse
	if err := json.NewDecoder(resp.Body).Decode(&riskResp); err != nil {
		return nil, err
	}

	return &riskResp, nil
}
