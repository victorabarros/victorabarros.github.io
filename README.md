# victorbarros.github.io

Victor Barros' personal website

## How to run locally w/ Docker 🐳

```sh
# Debug mode (hot reload)
make debug

# Production mode
make build-image
make run
```

### GCP

#### How push image to GCP Artifacts Registry

Define the tag you'll use. In the example below is **0.0.2**.
This will push your image to the Artifacts Registry.

```sh
make push-image TAG=0.0.2
```

After it's pushed, you may update the image in the Cloud Run.
