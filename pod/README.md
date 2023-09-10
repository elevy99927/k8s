## Create Pod

```
kubectl run mypod --image nginx
```

## List your pods (1)
```
kubectl get pod --show-labels
```
<table class="tg">
<thead>
  <tr>
    <th class="tg-ikqu">NAME</th>
    <th class="tg-ikqu">READY</th>
    <th class="tg-ikqu">STATUS</th>
    <th class="tg-ikqu">RESTARTS</th>
    <th class="tg-ikqu">AGE</th>
    <th class="tg-ikqu">LABELS</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-ikqu">mypod</td>
    <td class="tg-ikqu">1/1</td>
    <td class="tg-ikqu">Running</td>
    <td class="tg-ikqu">0</td>
    <td class="tg-ikqu">2m32s</td>
    <td class="tg-ikqu">run=mypod</td>
  </tr>
</tbody>
</table>


## Lable pod

```
kubectl label pod mypod app=someapp
```

## List your pods (2)
```
kubectl get pod --show-labels
```
<table class="tg">
<thead>
  <tr>
    <th class="tg-ikqu">NAME</th>
    <th class="tg-ikqu">READY</th>
    <th class="tg-ikqu">STATUS</th>
    <th class="tg-ikqu">RESTARTS</th>
    <th class="tg-ikqu">AGE</th>
    <th class="tg-ikqu">LABELS</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-ikqu">mypod</td>
    <td class="tg-ikqu">1/1</td>
    <td class="tg-ikqu">Running</td>
    <td class="tg-ikqu">0</td>
    <td class="tg-ikqu">2m32s</td>
    <td class="tg-ikqu">app=someapp,run=mypod</td>
  </tr>
</tbody>
</table>

