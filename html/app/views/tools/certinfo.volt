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
  <div class="row">
    {% if subject["common_name"] %}
      <div class="col-lg-12">
        <p>Common Name: {{ subject["common_name"] }}</p>
      </div>
    {% endif %}
    <div class="col-lg-12">
      {% if issuer["common_name"] %}
        <p>Issuer: {{ issuer["common_name"] }}</p>
      {% endif %}
      {% if issuer["organization"] %}
        <p>Organization: {{ issuer["organization"] }}</p>
      {% endif %}
      {% if issuer["organizational_unit"] %}
        <p>Organizational Unit: {{ issuer["organizational_unit"] }}</p>
      {% endif %}
      {% if issuer["locality"] %}
        <p>Locality: {{ issuer["locality"] }}</p>
      {% endif %}
      {% if issuer["province"] %}
        <p>Province: {{ issuer["province"] }}</p>
      {% endif %}
      {% if issuer["country"] %}
        <p>Country: {{ issuer["country"] }}</p>
      {% endif %}
    </div>
    <div class="col-lg-12">
      {% if sigalg %}
        <p>Signature Algorithm: {{ sigalg }}</p>
      {% endif %}
    </div>
    {% if not_before and not_after %}
      <div class="col-lg-12">
        <p>Valid: {{ not_before }} to {{ not_after }}</p>
      </div>
    {% endif %}
    {% if serial_number %}
      <div class="col-lg-12">
        <p>Serial Number: {{ serial_number }}</p>
      </div>
    {% endif %}
    {% if authority_key_id %}
      <div class="col-lg-12">
        <p>Authority Key ID: {{ authority_key_id }}</p>
      </div>
    {% endif %}
    {% if pem %}
      <div class="col-lg-12">
        <p>Certificate:</p>
        <textarea class="form-control" rows="40" disabled>{{ pem }}</textarea>
      </div>
    {% endif %}
  </div>
{% endif %}

