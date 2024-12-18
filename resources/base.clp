; templatki

(deftemplate GUI-state
   (slot id (default-dynamic (gensym*)))
   (slot text (default none))
   (slot question-state (default none))
   (slot answer (default none))
   (multislot answers)
   (slot state (default middle)))

(deftemplate state-list
   (slot now)
   (multislot history))

; rozpoczecie dzialania

((deffacts get-ready
   (state-list))


; pytania startowe (wybor sciezki) ================================================

(defrule path-choice                ;wybor sciezki
   =>
       (assert (GUI-state (text "Q: Just trust your gut!")
       (question-state path)
       (answers 1 2 3 4)))
)

(defrule starting-question1         ;Pytanie startowe nr1
   (logical (path 1))
   =>
       (assert (GUI-state (text "Q: Are you about to snap under the crushing weight of constant whining?


       1: \"Yes, This is all my kid talks about. I am slowly dying\"

       2: \"Actually, he never brought it up. I was just thinking...\"

       3: \"She just won't stop. MAKE IT STOP\"
       ")
       (question-state sq1)
       (answers 1 2 3)))
)

(defrule starting-question2         ;Pytanie startowe nr2
   (logical (path 2))
   =>
       (assert (GUI-state (text "Q: Do you mind if you kid never looks up from her phone again?


        1: \"Actually, I have strict rules about the amount of time she will spend on her phone.\"

        2: \"One sec, I'm just finishing a game of Bejeweled\"
        ")
       (question-state sq2)
       (answers 1 2)))
)

(defrule starting-question3         ;Pytanie startowe nr3
   (logical (path 3))
   =>
       (assert (GUI-state (text "Q: How will you feel when your kid drops and smashes the phone on the first day he has it?


        1: \"Now it looks like my phone. Neat!\"

        2: \"Excuse me while i curl up in a ball and weep.\"

        3: \"Fine. I am husk of my former self. I feel nothing\"
        ")
       (question-state sq3)
       (answers 1 2 3)))
)


(defrule starting-question4         ;Pytanie startowe nr4
   (logical (path 4))
   =>
       (assert (GUI-state (text "Q: Just the one phone?


        1: \"Dude. This isn't The Wire. How many phones does she need?\"
        ")
       (question-state sq4)
       (answers 1)))
)


; normalne pytania ================================================


(defrule question1              ;Pytanie nr1
   (logical (sq1 3))
   =>
       (assert (GUI-state (text "Q: Are you bankrolling this entire enterprise, player?


        1: \"They pay half, I pay half. JK, I pay for most of it.\"

        2: \"Yes. Against all scientific odds, I am made of money.\"

        3: \"No, my kid's takehome pay is higher than mine, so he's paying for all of it.\"
        ")
       (question-state q1)
       (answers 1 2 3)))
)

(defrule question2              ;Pytanie nr2
   (or
        (logical (q1 1))
        (logical (q1 2))
   )
   =>
       (assert (GUI-state (text "Q: Who will spend their hard-earned cash on apps, overages and other charges your kid makes \"by mistake?\"


        1: \"She will. I mentioned it twice, so I think she gets it.\"

        2: \"Whatever. I'm a human ATM.\"
        ")
       (question-state q2)
       (answers 1 2)))
)

(defrule question3              ;Pytanie nr3
   (or
        (logical (sq2 1))
        (logical (q6 2))
   )
   =>
       (assert (GUI-state (text "Q: HA HA good one. Do your kids always follow your rules?


        1: \"HELL YEAH. They better.\"

        2: \"Of course. They are my sweet angels <3.\"
        ")
       (question-state q3)
       (answers 1 2)))
)

(defrule question4              ;Pytanie nr4
   (or
        (logical (sq2 2))
        (logical (q6 1))
   )
   =>
       (assert (GUI-state (text "Q: Can you handle him losing his phone like, LITERALLY everywhere?


        1: \"Hang on. I can't find my phone. Can you call it?\"

        2: \"Nope. SHUT IT DOWN.\"
        ")
       (question-state q4)
       (answers 1 2)))
)

(defrule question5              ;Pytanie nr5
   (or
        (logical (q4 1))
        (logical (q4 2))
   )
   =>
       (assert (GUI-state (text "Q: Are you seriously shocked that he lost his phone?


        1: \"I guess not. Just leave me alone and let me drink.\"

        2: \"This is my first day with my kid. We're still getting to know each other.\"
        ")
       (question-state q5)
       (answers 1 2)))
)

(defrule question6              ;Pytanie nr6
   (logical (q3 1))
   =>
       (assert (GUI-state (text "Q: Do you think she will answer your urgent calls and texts right away/quickly/ever?


        1: \"No. It's like I'm invisible. Can you see me?\"

        2: \"I found this cell phone agreement online. She signed it, so i think we're good.\"
        ")
       (question-state q6)
       (answers 1 2)))
)

(defrule question7              ;Pytanie nr7
   (logical (sq1 1))
   =>
       (assert (GUI-state (text "Q:  Do you and your kid know about bullying?


        1: \"Um, yeah. Doi.\"
        ")
       (question-state q7)
       (answers 1)))
)

(defrule question8                  ;Pytanie nr8
   (or
        (logical (q5 1))
        (logical (q5 2))
        (logical (sq3 1))
        (logical (sq3 2))
        (logical (sq3 3))
   )
   =>
       (assert (GUI-state (text "Q: Will you pony up and get him another phone?


        1: \"Yes, but he will work it off with hard manual labour around the house until the end of days\"

        2: \"What? NO. Get a job, you mooch.\"

        3: \"Whatever. I'm a human ATM.\"
        ")
       (question-state q8)
       (answers 1 2 3)))
)

(defrule question9                  ;Pytanie nr9
   (logical (sq4 1))
   =>
       (assert (GUI-state (text "Q: Mmm-hmm. What will you do next year when she wants a new phone?


        1: \"I will tell the story of how we used to use land lines. And make her clean out the garage.\"

        2: \"whatever. I'm a human ATM.\
        ")
       (question-state q9)
       (answers 1 2)))
)

(defrule question10                 ;Pytanie nr10
   (or
        (logical (q3 2))
        (logical (q2 1))
   )
   =>
       (assert (GUI-state (text "Q: Do you have a HUMAN child?


        1: \"Kinda? I have a robot I built in my basement. I named him Kevin.\"
        ")
       (question-state q10)
       (answers 1)))
)

(defrule question11                 ;Pytanie nr11
   (logical (q7 1))
   =>
       (assert (GUI-state (text "Q: Are you being bullied right now?


        1: \"Yes. Hold me.\"

        2: \"No more than usual.\"
        ")
       (question-state q11)
       (answers 1 2)))
)

(defrule question12                 ;Pytanie nr12
   (or
        (logical (q13 1))
        (logical (q11 2))
   )
   =>
       (assert (GUI-state (text "Q: If you say yes, can you use this as leverage to het something you want?


        1: \"Sweet. I can get a hot tub in the backyard!.\"
        ")
       (question-state q12)
       (answers 1)))
)

(defrule question13                 ;Pytanie nr13
   (logical (q11 1))
   =>
       (assert (GUI-state (text "Q: Have you also promised her a puppy?


        1: \"No. I mean, maybe? IDK, I'm so tired.\"

        2: \"Yes. Finally, I shall be crowned as the greatest parent ever. Bow to me!\"
        ")
       (question-state q13)
       (answers 1 2)))
)

(defrule question14                     ;Pytanie nr14
   (or
        (logical (q8 1))
        (logical (q9 1))
   )
   =>
       (assert (GUI-state (text "Q: Are you going to shell out extra moeny for Apple Care, extra insurance or an unbreakable case?


        1: \"Is there an unbreakable case i can shove my kid into?.\"

        2: \"Whatever. I'm a human ATM.\"
        ")
       (question-state q14)
       (answers 1 2)))
)


; odpowiedzi koncowe ================================================


(defrule answer1                    ;Odpowiedz nr1
   (or
        (logical (sq1 2))
        (logical (q8 2))
        (logical (q14 1))
   )
   =>
       (assert (GUI-state (text "ANSWER:


        DON'T GET A PHONE.


        Why not spend that money on a Disney cruise? That should buy you at least a year.
        ")
        (state final)))
)

(defrule answer2                    ;Odpowiedz nr2
   (or
        (logical (q14 2))
        (logical (q12 1))
        (logical (q9 2))
        (logical (q8 3))
        (logical (q2 1))
   )
   =>
       (assert (GUI-state (text "ANSWER:


       GET THE PHONE AND DON'T LOOK BACK!


       You're aware of all of the frustrations, tears and money you'll go through, but it's still worth it.

       It's like having kids, except phones are way cooler.
        ")
        (state final)))
)

(defrule answer3                    ;Odpowiedz nr3
   (or
        (logical (q13 2))
        (logical (q1 3))
   )
   =>
       (assert (GUI-state (text "ANSWER:


        WHY ARE YOU EVEN ASKING?


        Get a phone, live your life and savour this beautiful time together.
        ")
        (state final)))
)

(defrule answer4                    ;Odpowiedz nr4
   (logical (q10 1))
   =>
       (assert (GUI-state (text "ANSWER:


        BUY KEVIN A PHONE!


        And congrats on creating your own A.I. Can you build me a Kevin too?
        ")
        (state final)))
)


; dzialanie gui ================================================

(defrule ask-question
   (GUI-state (id ?id))
   ?f <- (state-list (history $?s&:(not (member$ ?id ?s))))
   =>
   (modify ?f (now ?id) (history ?id ?s))
   (halt)
)

(defrule go-back
   ?f1 <- (prev ?qid)
   ?f2 <- (state-list (history $?b ?qid ?p $?e))
   =>
   (retract ?f1)
   (modify ?f2 (now ?p))
   (halt)
)

(defrule wait-for-answer
   (logical (GUI-state (id ?qid) (question-state ?name)))
   ?f <- (add-answer ?qid)
   =>
   (str-assert (str-cat "(" ?name ")"))
   (retract ?f)
)


(defrule got-answer
   (logical (GUI-state (id ?qid) (question-state ?name)))
   ?f <- (add-answer ?qid ?answer)
   =>
   (str-assert (str-cat "(" ?name " " ?answer ")"))
   (retract ?f)
)


(defrule changes-in-middle
   (transition ?qid ?answer)
   ?t1 <- (state-list (now ?qid) (history ?nid $?b ?qid $?e))
   (GUI-state (id ?qid) (answer ~?answer))
   ?t2 <- (GUI-state (id ?nid))
   =>
   (modify ?t1 (history ?b ?qid ?e))
   (retract ?t2)
)


(defrule changes-in-end
   ?t1 <- (transition ?qid ?answer)
   (state-list (history ?qid $?))
   ?t2 <- (GUI-state (id ?qid)
                    (answer ?expected)
                    (question-state ?name))
   =>
   (retract ?t1)
   (if (neq ?answer ?expected)
      then
      (modify ?t2 (answer ?answer)))
   (assert (add-answer ?qid ?answer))
)

