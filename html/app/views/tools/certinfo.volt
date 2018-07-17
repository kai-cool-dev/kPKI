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
    {% if names %}
      <div class="col-lg-12">
        <p>SANs: 
        {% for name in names %}
          {{ name }}
        {% endfor %}
        </p>
      </div>
    {% endif %}
     <div class="col-lg-12">
      <h5>INFO</h5>
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
    <div class="col-lg-12">
      <h5>ISSUER</h5>
      {% if issuer["common_name"] %}
        <p>{{ issuer["common_name"] }}</p>
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
    {% if sigalg %}
      <div class="col-lg-12">
          <p>Signature Algorithm: {{ sigalg }}</p>
      </div>
    {% endif %}
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

