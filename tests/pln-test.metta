!(import! &self ../pln/petta-pln)
;; ===========================================
;; TEST CASE 1: Modus Ponens (Basic Inference)
;; "If it is raining, the grass is wet. It is raining. Therefore..."
;; ===========================================

;; pln works on the following type of sentence/axiom structure
;; (Sentence 
;;     (Term)           ; e.g., (Implication (rain) (wet))
;;     (stv $s $c)      ; Truth Value: Strength (Probability) & Confidence
;;     (Evidence)       ; History: e.g., (1 2) - Who told me this?
;; )

!(println! ("--- Test Case 1: Modus Ponens ---"))

;; Define our terms
(= (rain) (Concept "It is raining"))
(= (wet)  (Concept "The grass is wet"))

;; Construct the Knowledge Base (KB)
;; Stamps (1) and (2) ensure the system treats these as distinct sources
(= (kb_mp) 
   (
     (Sentence ((rain) (stv 1.0 0.9)) (1))
     (Sentence ((Implication (rain) (wet)) (stv 0.9 0.8)) (2))
   )
)

;; Run Query: "Is the grass wet?"
!(PLN.Query (kb_mp) (wet))


;; ===========================================
;; TEST CASE 2: Deduction (Chaining Rules)
;; "A implies B. B implies C. Therefore A implies C."
;; ===========================================

!(println! "--- Test Case 2: Deduction Chain ---")

(= (A) (Concept "Socrates"))
(= (B) (Concept "Man"))
(= (C) (Concept "Mortal"))

;; Construct KB
;; Stamps (10) and (20) prevent self-revision
(= (kb_deduction)
   (
     (Sentence ((Implication (A) (B)) (stv 1.0 0.9)) (10))
     (Sentence ((Implication (B) (C)) (stv 1.0 0.9)) (20))
   )
)

;; Run Query: "Does Socrates imply Mortal?"
!(PLN.Query (kb_deduction) (Implication (A) (C)))


;; ===========================================
;; TEST CASE 3: Game Scenario (Tic-Tac-Toe Strategy)
;; "Connecting MOSES Logic to PLN"
;; ===========================================

!(println! ("--- Test Case 3: Tic-Tac-Toe (Encapsulated) ---"))

;; 1. We DEFINE the specific board state as a high-level Concept.
;; This effectively "Names" the pattern found by MOSES.
(= (center_empty_pattern) (Concept "BoardState_CenterEmpty"))

;; 2. We DEFINE the move
(= (play_center) (Concept "Move_PlayCenter"))

(= (kb_game_wrapper)
   (
     ;; Fact: "The Board matches the Center-Empty Pattern"
     ;; (Simple Concept -> High Confidence)
     (Sentence 
        ((center_empty_pattern) (stv 1.0 1.0)) 
        (100)
     )
     
     ;; Rule: "If Board matches Center-Empty -> Play Center"
     ;; (Simple Implication -> Modus Ponens applies perfectly)
     (Sentence 
        (
           (Implication (center_empty_pattern) (play_center)) 
           (stv 0.85 0.9)
        ) 
        (101)
     )
   )
)

;; Run Query
!(PLN.Query (kb_game_wrapper) (play_center))