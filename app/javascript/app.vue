<template>
  <v-app id="app">
    <GeneralHeader></GeneralHeader>
    <transition name="fade" mode="out-in">
      <router-view></router-view>
    </transition>
    <transition name="fade"  v-if="this.$store.getters.loading">
      <div class="loading-wrapper">
        <img src="~ajax-loader.gif" />
      </div>
    </transition>
  </v-app>
</template>

<script>
import "normalize.css";
import "ajax-loader.gif";
import GeneralHeader from "./components/modules/GeneralHeader";

export default {
  components: {
    GeneralHeader,
  },
};
</script>

<style lang="scss">
// body {
//   padding: 0;
// }
// #app {
//   background-color: whitesmoke;
// }
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s;
}

.loading-wrapper{
  width: 100vw;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.3);
  z-index: 500;
  img{
    width: 100px;
    height: 100px;
  }
}
</style>