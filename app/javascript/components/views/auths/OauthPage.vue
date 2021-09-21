<template>
  <div class="container">
    <h1>リダイレクトします</h1>
  </div>
</template>

<script>
export default {
  name: 'Oauth',
  created() {
    let path = '/'
    this.$store.dispatch('auth/setId')
    .then((res)=>{
      console.log(res.data)
      this.$store.commit('auth/setId',res.data.id)
      this.$router.push(path)
    }).catch((err)=>{
      path = '/login'
      this.$router.push(path)
    });
  }
}
</script>

<style scoped lang="scss">
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 32px;
}
</style>