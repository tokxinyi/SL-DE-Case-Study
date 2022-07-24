# Pipelining
![DAG](https://github.com/tokxinyi/SL-DE-Case-Study/blob/main/DAG.png)

# Enriching company data with external webhooks & APIs
## Webhook
![Webhook](https://github.com/tokxinyi/SL-DE-Case-Study/blob/main/Webhook.png)

### Pros of Webhooks
1. Provides applications and services with near real-time information because webhook is sent when there is an update in the information (event-based triggers)

### Cons of Webhooks
1. There is less control over the flow of data because you have to accept the amount of data sent by the webhooks. However, there is a way to mitigate this by storing the 'extra' dataset into a cloud bucket and retrieve it when we can process the extra information.
2. Not able to scale the paging size as freely accordingly as compared to APIs.



## API
![DAG](https://github.com/tokxinyi/SL-DE-Case-Study/blob/main/API.png)

### Pros of APIs
1. Scalable
2. More visibility to data consumption
3. Able to control the data flow within the system because the paging size can be adjusted according. This will help to determine the amount of data that we allow flowing in the system at any given time.
4. Bi-directional data communication

### Cons of APIs
1. In the case when there is not much updates in the system, multiple API calls will have to be made to get the latest updates. If there is a API rate limit, APIs may not be the best choice to get the latest information.