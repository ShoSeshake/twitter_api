<template>
  <div class="page-wrapper" name="root-page">
    <table>
      <thead>
        <tr>
          <th>ユーザー名</th>
          <th>いいね数</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>
            <a :href="'https://twitter.com/' + user.username" target="_blank">
              {{ user.name }}
            </a>
          </td>
          <td>({{ user.likes.length }})</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      users: [],
    };
  },
  mounted() {
    this.$store.dispatch('getUsers')
    .then((res)=>{
      this.$store.commit('setUsers',res.data)
      this.users = this.$store.getters.users;
      return;
    }).catch((err)=>{
      console.log(err)
    });
  },
};
</script>

<style lang="scss" scoped>
.page-wrapper {
  background-color: white;
  padding: 32px 8px 0;
  max-width: 600px;
  margin: 0 auto;
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