# Below document talks about how to use ARGO rollout method to setup Kubernetes Blue Green Deployment setup 

Argo Rollouts → Blue/Green Deployment 

Progressive traffic shifting, rollback support, dependency is it requires Argo Rollouts setup
Below defines the Argo Rollout resource, replacing the traditional Deployment. It manages Blue-Green deployments with automatic promotion after 24 hours.

Benefits of Using ReplicaSets with Argo Rollouts: 
✔ No Pod downtime when switching between Blue and Green.
✔ Immediate rollback (old ReplicaSet is always ready).
✔ Allows manual approvals before promotion.
✔ Seamless traffic switching via active/preview services.

```
Issues with Deployment:
No parallel Blue-Green versions.
Rollbacks require recreating Pods.
Traffic shifting is not immediate.

Argo Rollouts with ReplicaSets (Blue-Green)
Argo Rollouts keeps two ReplicaSets at the same time.
It manages traffic switching via activeService and previewService.
If the new version fails, rollback is instant (old ReplicaSet is still live).
```

Below is the folder structure for the sample app
```
my-app/
│── charts/
│── templates/
│   ├── rollout.yaml
│   ├── service-active.yaml
│   ├── service-preview.yaml
│   ├── argocd-application.yaml
│── values.yaml
│── Chart.yaml
│── readme.md
```

# Deployment model with ArgoRollout feature

Argo Rollouts manages ReplicaSets directly, keeping two versions active at the same time (Blue & Green), allowing immediate rollbacks, traffic shifting, and manual approvals.


🚀 Key Takeaways
✔ Argo Rollouts uses a single Rollout resource to manage ReplicaSets directly (no Deployments required).
✔ Blue-Green deployments are controlled by activeService & previewService, making traffic switching instant.
✔ Rollbacks are instant since the old ReplicaSet is still running.
✔ Rolling updates (Deployments) cause downtime, while Argo Rollouts prevents it.

Would you like an example of manual approval before switching to Green using Argo Rollouts? 🚀

# Deployment Flow:
![Alt text](images/image2.png)

# Key Differences Between Deployment and ReplicaSets Model in Argo Rollouts
![Alt text](images/image3.png)

🚀 Deployment Steps
1️⃣ Install Argo Rollouts
```
kubectl apply -n argocd -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```
2️⃣ Install the Helm Chart
```
helm install my-app ./my-app --namespace my-app
```
3️⃣ Deploy the ArgoCD Application
```
kubectl apply -f templates/argocd-application.yaml
```
4️⃣ Check Rollout Status
```
kubectl argo rollouts get rollout my-app-rollout -n my-app
```
🎯 Upgrading to a New Version (Deploying Green)
To deploy a new Green version, update values.yaml:
```
image:
  tag: v2  # Upgrade to v2
```
Then, upgrade the Helm release:

```
helm upgrade my-app ./my-app --namespace my-app
```
my-app-preview (Green) will now point to v2.
Wait for testing & validation before promotion.
If autoPromotionEnabled: true, traffic automatically shifts after 24 hours.
🔄 Rolling Back to Blue (If Green Fails)
If something is wrong before promotion, abort the rollout:
```
kubectl argo rollouts abort my-app-rollout -n my-app
```
This keeps Blue (v1) running and prevents switching to Green.

