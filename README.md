# ABN Microservice
A small project to learn Julia. This microservice has the following features;
- Validate ABNs
- Create ABNs from ACNs or from random seed

Details about the check digit algorithm are from https://abr.business.gov.au/Help/AbnFormat  
Details to generate a ABN are from https://stackoverflow.com/questions/15503188/how-to-generate-an-australian-abn-number

# Deploy
run docker build -t abn-service .  
run docker run -p 8000:9111 abn-service

# Todo
- Integrate with ABR ABN lookup service to get business details