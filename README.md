# Validate DD Service

Validate a [`service.datadog.yaml` metadata file][dd-docs] using [JSON
Schema][jsonschema-docs].

[dd-docs]: https://docs.datadoghq.com/service_catalog/adding_metadata/#service-definition-yaml-files
[jsonschema-docs]: https://json-schema.org/

There are probably simpler ways for you to implement a Workflow that
accomplishes most of what you need (e.g. just install and execute something like
[`ajv`][ajv]). However, we created this Action to:

- Support multiple services as `---`-delimited Yaml documents
- Automate respecting the `schema-version` key

[ajv]: https://github.com/ajv-validator/ajv-cli#readme

## Example

```yaml
on:
  pull_request:
    paths:
      - service.datadog.yaml

jobs:
  validate-dd-service:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          sparse-checkout: service.datadog.yaml
          sparse-checkout-cone-mode: false
      - uses: freckle/validate-dd-service-action@v1
```

## Inputs

- **path**: Path to the file to validate. Default is `service.datadog.yaml`.
- **fail**: Fail on any validation errors? Default is `true`.

## Outputs

- **invalid-services**: A JSON array of objects for any invalid services found.
  Each object has a `name` and `errors` key.

  For example,

  ```json
  [
    {
      "name": "example-app-api",
      "errors": [
        "The property '#/links/0/url' of type null did not match the following type: string in schema 0afde55a-9ab5-543c-b02a-06065d9d613e#",
        "The property '#/links/1/url' of type null did not match the following type: string in schema 0afde55a-9ab5-543c-b02a-06065d9d613e#",
        "The property '#/integrations/pagerduty' of type object did not match the following type: string in schema 0afde55a-9ab5-543c-b02a-06065d9d613e"
      ]
    }
  ]
  ```

---

[LICENSE](./LICENSE) | [CHANGELOG](./CHANGELOG)
