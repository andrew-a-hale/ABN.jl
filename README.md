# ABN Microservice
A small project to learn Julia and constrast with dotnet. This microservice has the following features;
- Validate ABNs
- Create ABNs from ACNs or from random seed

Details about the check digit algorithm are from https://abr.business.gov.au/Help/AbnFormat  
Details to generate a ABN are from https://stackoverflow.com/questions/15503188/how-to-generate-an-australian-abn-number

# Deploy
kubectl apply -f deploy/abn-depl.yaml
kubectl apply -f deploy/abn-np-srv.yaml

# Todo
- Integrate with ABR ABN lookup service to get business details