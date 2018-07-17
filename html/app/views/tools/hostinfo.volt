<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Hostinfo - SSL Host Test</h2>
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
  <div class="row">
    <div class="col-lg-12">
      {% if subject["common_name"] %}
        <p>Issuer: {{ subject["common_name"] }}</p>
      {% endif %}
      {% if subject["organization"] %}
        <p>Organization: {{ subject["organization"] }}</p>
      {% endif %}
      {% if subject["organizational_unit"] %}
        <p>Organizational Unit: {{ subject["organizational_unit"] }}</p>
      {% endif %}
      {% if subject["locality"] %}
        <p>Locality: {{ subject["locality"] }}</p>
      {% endif %}
      {% if subject["province"] %}
        <p>Province: {{ subject["province"] }}</p>
      {% endif %}
      {% if subject["country"] %}
        <p>Country: {{ subject["country"] }}</p>
      {% endif %}
    </div>
  </div>
{% endif %}

