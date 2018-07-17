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
    {% if connectivity %}
      <div class="col-lg-12">
        <h5>CONNECTIVITY</h5>
        <p>DNS Lookup: {{ connectivity["DNSLookup"]["grade"] }} (
        {% for ip in connectivity["DNSLookup"]["output"] %}
          {{ ip }}
        {% endfor %}
        )</p>
        <p>TCP Connection: {{ connectivity["TCPDial"]["grade"] }}</p>
        <p>TLS Connection: {{ connectivity["TLSDial"]["grade"] }}
        {% if connectivity["TLSDial"]["error"] %}
          ( {{ connectivity["TLSDial"]["error"] }} )
        {% endif %}
        </p>
      </div>
    {% endif %}
    {% if tlssession %}
      <div class="col-lg-12">
        <p>TLS Session Resume: {{ tlssession["grade"] }}
        {% if tlssession["error"] %}
          ( {{ tlssession["error"] }} )
        {% endif %}
        </p>
      </div>
    {% endif %}
    {% if ciphersuite %}
      <div class="col-lg-12">
        <h5>CIPHERS</h5>
        <p>Grade: {{ ciphersuite["grade"]  }}</p>
      </div>
    {% endif %}
  </div>
{% endif %}
