<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
  <table class="table table-hover">
    <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">Name</th>
        <th scope="col">Active</th>
        <th scope="col" colspan="2"></th>
      </tr>
    </thead>
    <tbody>
    {% for profile in page.items %}
      <tr>
        <th scope="row">{{ profile.id }}</th>
        <td>{{ profile.name }}</td>
        <td>{{ profile.name }}</td>
        <td>{{ profile.active == 'Y' ? 'Yes' : 'No' }}</td>
        <td>{{ link_to("profiles/edit/" ~ profile.id, 'Edit', "class": "btn btn-light form-control") }}</td>
        <td>{{ link_to("profiles/delete/" ~ profile.id, 'Delete', "class": "btn btn-danger form-control") }}</td>
      </tr>
    {% else %}
      <tr colspan="8">
        <th>No profiles are recorded</th>
      </tr>
    {% endfor %}
    </tbody>
  </table>
  </div>
</div>
<div class="row">
  <div class="col-lg-2">
    {{ link_to("profiles/search", 'First', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-2">
    {{ link_to("profiles/search?page=" ~ page.before, 'Previous', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-4">
    <p class="btn form-control">{{ page.current }}/{{ page.total_pages }}</p>
  </div>
  <div class="col-lg-2">
    {{ link_to("profiles/search?page=" ~ page.next, 'Next', "class": "btn btn-light form-control") }}
  </div>
  <div class="col-lg-2">
    {{ link_to("profiles/search?page=" ~ page.last, 'Last', "class": "btn btn-light form-control") }}
  </div>
</div>
<div class="row">
  <div class="col-lg-6">
    {{ link_to("profiles/index", "Back to search", "class":"btn btn-light form-control") }}
  </div>
  <div class="col-lg-6">
    {{ link_to("profiles/create", "Create new profile", "class":"btn btn-light form-control") }}
  </div>
</div>
