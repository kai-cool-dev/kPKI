<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Certinfo</h2>
  </div>
</div>

<form method="POST">
  <div class="row">
    <div class="col-lg-8">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Domain</span>
        </div>
        {{ form.render("domain") }}
      </div>
    </div>
    <div class="col-lg-4">
      {{ submit_button("Go", "class": "btn btn-light form-control") }}
    </div>
  </div>
</form>

{% if request.isPost()%}
  <div class="row bg-primary">
    <div class="col-lg-12">
      <h6>{{ subject["common_name"] }} {{ serial_number }}</h6>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-6">
      <h6 class="card-title">ISSUER</h6>
      <p>{{ issuer["common_name"] }}</p>
      <p>{{ issuer["locality"] }}, {{ issuer["province"] }}, {{ issuer["country"] }}</p>
    </div>
  </div>
{% endif %}
