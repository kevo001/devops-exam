**DevOps Exam Candidate 54**

**Exercise 1:**
- **HTTP Endepunkt:**
  https://ifae21edv2.execute-api.eu-west-1.amazonaws.com/Prod/generate-image/

Example prompt on Postman:
{"prompt":"a big hippo driving a car"}
  
- **Workflow run:**
  https://github.com/kevo001/devops-exam/actions/runs/11810564556
  
**Exercise 2:**
- **Workflow run (main):**
  https://github.com/kevo001/devops-exam/actions/runs/11827872880/job/32956862131
  
- **Workflow run (other branch):**
  https://github.com/kevo001/devops-exam/actions/runs/11827919185/job/32957002039
  
- **SQS-queue URL:**
  https://sqs.eu-west-1.amazonaws.com/244530008913/image_request_queue_54
  
**Exercise 3:**
- **Workflow run:**
  https://github.com/kevo001/devops-exam/actions/runs/11860106027
  
- **Docker image name:**
  kevo001/sqs-client:latest
  
  docker run -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/image_request_queue_54 kevo001/sqs-client:latest "me on top of a pyramid"
  
- **Explanation of Tag strategy:**

  Jeg valgte en taggestrategi som er basert på semantic versioning med en latest tag for enkel deployment. Denne latest taggen fungerer som selve standardtaggen for den nyeste versjonen, mens v1.0.0 holder
  styr over den spesifikke utgivelsen. Dette gjør at versjonhåndtering blir tydelig og fleksibelt for fremtidige oppdatteringer. 

**Exercise 5:**
- **Automatisering og kontinuerlig levering (CI/CD): Hvordan påvirker serverless-arkitektur sammenlignet med mikrotjenestearkitektur CI/CD-pipelines, automatisering, og utrullingsstrategier?**
  
  I en serverless arkitektur brytes applikasjonen ned i små funksjoner, der hver funksjon har sin egen livssyklus. Dette gjør det mulig med raskere utviklings- og utrullingssykluser
  fordi funksjonene er mindre komplekse og enklere å deploye. Automatiseringsverktøy som Serverless Framework og AWS CodePipeline gir gode verktøy for å administrere slike systemer.
  Samtidig kan CI/CD bli mer komplekst fordi hver funksjon trenger sin egen pipeline for testing, utrulling og overvåkning. Koordinering av alle disse komponentene kan derfor være tidkrevende.
  
  Mikrotjenester består av færre, men større deploybare enheter. Disse er ofte mer selvstendige og lettere å håndtere med standard CI/CD-strategier.
  Ulempen er at mikrotjenester som regel er mer komplekse å bygge og teste i sin helhet, noe som kan føre til lengre utrullingssykluser sammenlignet med serverless.
  
  Serverless gir raskere deployments, men krever mer avanserte pipelines. Mikrotjenester er enklere å håndtere i CI/CD, men krever mer tid per deployment.


- **Observability (overvåkning): Hvordan endres overvåkning, logging og feilsøking når man går fra mikrotjenester til en serverless arkitektur? Hvilke utfordringer er spesifikke for observability i en FaaS-arkitektur?**
  
  Overvåkning er et område hvor serverless og mikrotjenester skiller seg mye. I serverless arkitektur er det utfordrende å få oversikt, siden applikasjonen består av mange små, distribuerte funksjoner.
  Logging og sporing blir derfor fragmentert, og det kan være vanskelig å få et helhetlig bilde av systemet. Verktøy som AWS CloudWatch Logs og AWS X-Ray hjelper med logging og sporing, men det krever
  mye innsats for å sette opp et effektivt overvåkningssystem.

  I mikrotjenester er overvåkning enklere fordi tjenestene dekker mer helhetlige deler av applikasjonen. Dette gjør det lettere å spore ytelse og finne feil. Verktøy som
  Prometheus og Grafana fungerer godt, men ulempen er at kompleksiteten øker dersom det blir mange avhengigheter mellom tjenestene.

  Serverless krever mer avanserte verktøy og strategier for overvåkning. Mikrotjenester er enklere å overvåke, men kan bli mye mer komplisert og utfordrende når avhengiheter blir komplekse.


- **Skalerbarhet og kostnadskontroll: Diskuter fordeler og ulemper med tanke på skalerbarhet, ressursutnyttelse, og kostnadsoptimalisering i en serverless kontra mikrotjenestebasert arkitektur.**
  
  Når det gjelder skalerbarhet så er serverless svært enkelt. Tjenestene blir skalert automatisk basert på behov uten at utviklerne trenger å administrere infrastrukturen.
  Dette gir også en fleksibel kostnadsmodell, der man kun betaler for ressursene som faktisk blir brukt. Ulempen er at kostnadene kan bli uforutsigbare ved høy trafikk.

  Mikrotjenester gir mer kontroll over skalering, men krever manuell konfigurasjon ofte ved hjelp av plattformer som Kubernetes. Selv om dette gir forutsigbare
  kostnader så kan ressursutnyttelsen være mindre effektiv. Man må ofte planlegge for "worst-case"-belastning.

  Serverless er kostnadseffektivt og blir skalert automatisk, men kan være uforutsigbart. Mikrotjenester gir mer kontroll og forutsigbare kostnader, men krever manuell administrasjon for å oppnå effektiv skalering.


- **Eierskap og ansvar: Hvordan påvirkes DevOps-teamets eierskap og ansvar for applikasjonens ytelse, pålitelighet og kostnader ved overgang til en serverless tilnærming sammenlignet med en mikrotjeneste-tilnærming?**

  Serverless gir mindre arbeid og ansvar siden skyleverandøren tar seg av infrastrukturen. Dette lar teamet fokusere mer på forretningslogikk og mindre på drift.
  Med det derimot så kan begrenset kontroll over infrastrukturen være frustrerende for et team med spesifikke ytelsesbehov.
  
  Mikrotjenester gir teamet full kontroll over infrastrukturen. Det gjør at man får større muligheter for tilpasning og optimalisering. Ulempen er at arbeidsmengden økes med tanke på drift, vedlikehold og feilsøking.

  Serverless gir mindre arbeid og ansvar for et team, men gir mindre fleksibilitet. Mikrotjenester krever mer ansvar, men gir større muligheter for tilpasning.

