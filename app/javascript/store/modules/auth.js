import axios from "axios";

export default {
  namespaced: true,
  state: {
    id: null,
  },
  getters: {
    id: (state) => state.id,
  },
  mutations: {
    setId(state, id) {
      state.id = id;
    },
  },
  actions: {
    setId() {
      return axios.get("/api/v1/users/set_id");
    },
  },
};
