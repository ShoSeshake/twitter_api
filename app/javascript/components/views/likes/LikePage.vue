<template>
  <v-container>
    <form>
      <v-col cols="12" md="4">
        <v-form ref="form">
          <v-text-field v-model="keyword" label="キーワード"></v-text-field>
        </v-form>
        <v-slider
          v-model="max_results"
          label="最大いいね数"
          max="100"
          min="10"
          thumb-label
        >
          <div>
            {{ max_results }}
          </div>
        </v-slider>
      </v-col>
      <v-btn color="success" @click="submit"> いいねをつける </v-btn>
    </form>
  </v-container>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      keyword: "",
      max_results: 100,
    };
  },
  methods: {
    submit() {
      axios
        .post("/api/v1/likes", {
          keyword: this.keyword,
          max_results: this.max_results,
        })
        .then((res) => {
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
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
table,
tbody,
thead {
  display: block;
}
tr {
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