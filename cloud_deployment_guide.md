# Step-by-Step: Secure Cloud Run & Cloud SQL Setup

This guide will help you close your database to the public internet and connect your application securely using the **Cloud SQL Auth Proxy** (the built-in method for Cloud Run).

---

## 1. Enable Required APIs
Before you start, Google needs permission to let these services talk to each other.
1.  Go to the **[Library](https://console.cloud.google.com/apis/library)** in your Google Cloud Console.
2.  Search for **"Cloud SQL Admin API"**.
    > [!IMPORTANT]
    > If it is not enabled, click **ENABLE**. Cloud Run cannot connect without this.

---

## 2. Secure your Cloud SQL Database
Currently, your database is likely open to "all IPs" or a specific "Allowlist". We want to change it to "Zero Public Access".

1.  Open the **[Cloud SQL Instances](https://console.cloud.google.com/sql/instances)** page.
2.  Click on the name of your instance: **`hospital-db`**.
3.  In the left-hand menu, click **Connections**.
4.  Click the **Networking** tab.
5.  Scroll down to **Authorized networks**.
6.  Click the **Trash/Bin icon** next to every entry there (delete them all).
7.  Click **SAVE** at the bottom.
    *   *Result*: Your database is now "invisible" to the public internet. Only Google-authorized services (like your Cloud Run app) can talk to it.

---

## 3. Configure Cloud Run to Connect
Now we tell Cloud Run to create a secure, internal tunnel to that database.

1.  Open the **[Cloud Run](https://console.cloud.google.com/run)** page.
2.  Click on your service name.
3.  Click **EDIT & DEPLOY NEW REVISION** at the top.
4.  Scroll down to the **Cloud SQL connections** section.
5.  Click **ADD CONNECTION**.
6.  Select **`hospital-db`** from the dropdown menu.
7.  Now go to the **Variables & Secrets** tab in the same screen.
8.  Click **ADD VARIABLE** for each of these:
    *   **Name**: `INSTANCE_CONNECTION_NAME` | **Value**: (You can find this on the Cloud SQL Overview page; it looks like `project:region:hospital-db`).
    *   **Name**: `DB_NAME` | **Value**: `hospital`
    *   **Name**: `DB_USER` | **Value**: `root`
    *   **Name**: `DB_PASS` | **Value**: (Your database password).

9. Scroll to the bottom and click **DEPLOY**.

---

## 4. Why this is safe
*   **No IP Allowlist**: Since Cloud Run is now "connected" via the internal tunnel (the connection you added in Step 3), it doesn't need an IP address. 
*   **Encrypted Tunnel**: The connection between your app and the database is now encrypted and managed by Google.
*   **Bots Blocked**: Bots on the internet searching for open databases will find nothing, as Step 2 removed all public access.

---

## 5. (Optional) Using Secret Manager
Instead of putting your password in a variable (Step 3.8), you can clicks "REFS SECRETS" to hide it even from people who have access to the Cloud Run console.
