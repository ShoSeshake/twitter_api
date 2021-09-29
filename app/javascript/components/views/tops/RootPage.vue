<template>
  <div class="page-wrapper" name="root-page">
    <table>
      <thead>
        <tr>
          <th>ユーザー名</th>
          <th>いいね数</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>
            <a :href="'https://twitter.com/' + user.username" target="_blank">
              {{ user.name }}
            </a>
          </td>
          <td>({{ user.likes_count }})</td>
          <td>
            <v-btn
              class="mx-2"
              fab
              dark
              small
              color="pink"
              @click="likeTweets(user.id)"
            >
              <v-icon dark> mdi-heart </v-icon>
            </v-btn>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      users: [],
    };
  },
  mounted() {
    this.$store
      .dispatch("getUsers")
      .then((res) => {
        this.$store.commit("setUsers", res.data);
        this.users = this.$store.getters.users;
        return;
      })
      .catch((err) => {
        console.log(err);
      });
  },
  methods: {
    likeTweets(id) {
      console.log(id)
        axios
        .post("/api/v1/likes", {
          user_id: id
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
  max-width: 800px;
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
  width: 80%;
  border: 1px solid lightgrey;
  padding: 2px;
}
td:not(:first-child),
th:not(:first-child) {
  width: 10%;
  margin-left: 1px;
  text-align: center;
}
</style>