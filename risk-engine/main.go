package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

type RiskRequest struct {
	Amount     int64  `json:"amount"`
	CreditCard string `json:"creditCard"`
}

type RiskResponse struct {
	Status string `json:"status"`
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
	r.Post("/risk-analysis", handleRiskAnalysis)
	r.Get("/health", handleHealthCheck)

	log.Println("Servidor iniciado na porta 8083")
	log.Fatal(http.ListenAndServe(":8083", r))
}

func handleRiskAnalysis(w http.ResponseWriter, r *http.Request) {
	var request RiskRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "Erro ao decodificar requisição", http.StatusBadRequest)
		return
	}

	response := RiskResponse{
		Status: "APPROVED",
	}

	if request.CreditCard == "INVALID_CARD" {
		response.Status = "DENIED"
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func handleHealthCheck(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "healthy"})
}
