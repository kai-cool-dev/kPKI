<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

{% if cert.status == "revoked" %}
  <div class="row">
    <div class="col-lg-12">
      {{ link_to("certificate", "Go Back", "class":"btn btn-light form-control") }}
    </div>
  </div>
{% else %}
  <div class="row">
    <div class="col-lg-6">
      {{ link_to("certificate", "Go Back", "class":"btn btn-light form-control") }}
    </div>
    <div class="col-lg-6">
      {{ link_to("certificate/revoke/" ~ cert.serial_number, 'Revoke', "class": "btn btn-danger form-control") }}
    </div>
  </div>
{% endif %}

<div class="row">
  <div class="col-lg-12">
    <h2>Show
      "{% if cert.ca_label %}
        {{ cert.ca_label }}
      {% else %}
        {{ cert.serial_number }}
      {% endif %}
      "</h2>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>SANs</h2>
  </div>
  {% for san in  data["sans"] %}
    <div class="col-lg-4">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">SAN</span>
        </div>
        <input type="text" class="form-control" disabled value="{{ san }}">
      </div>
    </div>
  {% endfor %}
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Issued for</h2>
  </div>
  {% for key,value in  data["subject"] %}
    <div class="col-lg-4">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">{{key}}</span>
        </div>
        <input type="text" class="form-control" disabled value="{{ value }}">
      </div>
    </div>
  {% endfor %}
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Issuer</h2>
  </div>
  {% for key,value in  data["issuer"] %}
    <div class="col-lg-4">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">{{key}}</span>
        </div>
        <input type="text" class="form-control" disabled value="{{ value }}">
      </div>
    </div>
  {% endfor %}
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Misc</h2>
  </div>
  {% for key,value in  data["misc"] %}
    <div class="col-lg-4">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">{{key}}</span>
        </div>
        <input type="text" class="form-control" disabled value="{{ value }}">
      </div>
    </div>
  {% endfor %}
</div>

<div class="row">
  <div class="col-lg-4">
    <form method="post">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Label</span>
        </div>
        {{ form.render("ca_label") }}
        <div class="input-group-append">
          <button class="btn btn-success" type="submit" id="button-addon2">Save</button>
        </div>
      </div>
    </form>
  </div>
  <div class="col-lg-4">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="basic-addon1">Serial</span>
      </div>
      <input type="text" class="form-control" disabled value="{{ cert.serial_number }}">
    </div>
  </div>
  <div class="col-lg-4">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="basic-addon1">Expiry</span>
      </div>
      <input type="text" class="form-control" disabled value="{{ cert.expiry }}">
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Certificate Public Key</h2>
  </div>
  <div class="col-lg-12">
    <div class="input-group mb-3">
      <textarea rows="30" class="form-control" disabled>{{ cert.pem }}</textarea>
    </div>
  </div>
</div>
