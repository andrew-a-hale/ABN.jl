# ABN Microservice
A small project in Julia to constrast with dotnet. This microservice has the following features;
- Validate ABNs
- Create ABNs from ACNs or from random seed

Details about the check digit algorithm are from https://abr.business.gov.au/Help/AbnFormat  
Details to generate a ABN are from https://stackoverflow.com/questions/15503188/how-to-generate-an-australian-abn-number

# Deploy
kubectl apply -f deploy/abn-depl.yaml
kubectl apply -f deploy/abn-np-srv.yaml

# Todo
- Integrate with ABR ABN lookup service (RPC) to get business details
- Split into 2 services; 
    - datastore of business records
    - validator service + lookup service (wrap the ABR ABN lookup endpoint)