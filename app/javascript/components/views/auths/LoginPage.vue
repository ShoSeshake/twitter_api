<template>
  <div class="page-wrapper">
    <a href="/omniauth/twitter">Twitter</a>
  </div>
</template>

<script>
export default {
};
</script>

<style lang="scss" scoped>
.page-wrapper {
  background-color: white;
  padding: 32px 8px 0;
  max-width: 600px;
  margin: 0 auto;
  min-height: 90vh;
}
table,tbody,thead{
  display: block;
}
tr{
  border: 1px transparent solid;
  display: flex;
}
td,
th {
  display: block;
  width: 85%;
  border: 1px solid lightgrey;
  padding: 2px;
}
td:not(:first-child),
th:not(:first-child) {
  width: 15%;
  margin-left: 1px;
  text-align: center;
}
</style>