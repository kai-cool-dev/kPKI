<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Create new Certificate</h2>
  </div>
</div>

<form method="post" class="form-search">
  <div class="row">
    <div class="col-lg-12">
      <h2>Common Name / SAN</h2>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Common Name</span>
        </div>
        {{ form.render("CN") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">SAN</span>
        </div>
        {{ form.render("hosts") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <h2>Issued for</h2>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Organisation</span>
        </div>
        {{ form.render("O") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Organisation Unit</span>
        </div>
        {{ form.render("OU") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Locality</span>
        </div>
        {{ form.render("L") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">State</span>
        </div>
        {{ form.render("ST") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Country</span>
        </div>
        {{ form.render("C") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <h2>Key Encryption</h2>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Algorithm</span>
        </div>
        {{ form.render("algo") }}
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Key Size</span>
        </div>
        {{ form.render("keysize") }}
      </div>
    </div>
  </div>
</form>
