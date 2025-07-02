# Lab 4 – Using Helm Functions in Templates

**Goal:** Apply Sprig helper functions for string manipulation.

## Transform requirements:

* `dbname` → uppercase + quote
* `eat`   → uppercase, truncate to 13 chars, quote
* `drink` → uppercase

## Example values.yaml:

```yaml
dbname: musicdb
eat: spaghetti_al_pesto
drink: coffee
```

## configmap.yaml snippet:

```yaml
data:
  dbname: {{ quote (upper .Values.dbname) }}
  eat:    {{ quote (trunc 13 (upper .Values.eat)) }}
  drink:  {{ quote (upper .Values.drink) }}
```

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm