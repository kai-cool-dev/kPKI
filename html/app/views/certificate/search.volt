<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
    <h2>Search results</h2>
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
    <table class="table table-hover">
      <thead>
        <tr>
          <th scope="col">Serial</th>
          <th scope="col">Status</th>
          <th scope="col">CA Label</th>
          <th scope="col">Expiry</th>
          <th scope="col" colspan="2"></th>
        </tr>
      </thead>
      <tbody>
      {% for cert in page.items %}
        <tr>
          <th scope="row">{{ cert.serial_number }}</th>
          <td>{{ cert.status }}</td>
          <td>{{ cert.ca_label }}</td>
          <td>{{ cert.expiry }}</td>
          <td>{{ link_to("certificate/show/" ~ cert.serial_number, 'Show', "class": "btn btn-light form-control") }}</td>
          <td>{{ link_to("certificate/revoke/" ~ cert.serial_number, 'Revoke', "class": "btn btn-danger form-control") }}</td>
        </tr>
      {% else %}
        <tr colspan="8">
          <th>No users are recorded</th>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>
<div class="row">
  <div class="col-lg-2">
    {{ link_to("certificate/search", 'First', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-2">
    {{ link_to("certificate/search?page=" ~ page.before, 'Previous', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-4">
    <p class="btn form-control">{{ page.current }}/{{ page.total_pages }}</p>
  </div>
  <div class="col-lg-2">
    {{ link_to("certificate/search?page=" ~ page.next, 'Next', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-2">
    {{ link_to("certificate/search?page=" ~ page.last, 'Last', "class": "btn btn-light form-control") }}
  </div>
</div>
