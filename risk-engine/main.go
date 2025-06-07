package main

import (
	"encoding/json"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

type RiskResponse struct {
	Status string `json:"status"`
}

func main() {
	r := chi.NewRouter()

	// Middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	// Rotas
	r.Get("/risk-analysis", handleRiskAnalysis)

	log.Println("Servidor iniciado na porta 8080")
	log.Fatal(http.ListenAndServe(":8080", r))
}

func handleRiskAnalysis(w http.ResponseWriter, r *http.Request) {
	// Gera um resultado aleatório
	rng := rand.New(rand.NewSource(time.Now().UnixNano()))
	result := "ok"
	if rng.Float32() < 0.5 {
		result = "not ok"
	}

	response := RiskResponse{
		Status: result,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
