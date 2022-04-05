# Handling errors gracefully Dartpad Workshop

Errors can happen anytime in any application. Showing proper messages to your app users will significantly boost their experiences, but how can you do that? In this workshop, we are going beyond try/catch and will handle errors by creating our customer failure class as well as a widget and we will show proper messages based on the received messages.

## Quickstart (Firebase Hosting)

1. Fork this repository

2. Install the [Firebase CLI](https://firebase.google.com/docs/cli)

3. Set the default project ID in `.firebaserc`:

```json
{
  "projects": {
    "default": "handling-errors-gracefully"
  }
}
```

4. Edit the files in `public/` to create your own step-by-step workshop. The
   `meta.yaml` to configures the metadata such as the project type (Dart or
   Flutter), number of steps, and title.

5. Deploy to Firebase:

```bash
firebase deploy
```

5. Load in DartPad using the following URL, replacing `handling-errors-gracefully`
   with your project ID:

```bash
https://dartpad.dev/workshops.html?webserver=https://handling-errors-gracefully.web.app
```
