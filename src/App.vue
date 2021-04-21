<template>
  <v-app id="inspire">

    <v-app-bar color="deep" dark       shrink-on-scroll>
      <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon>
      <v-toolbar-title>Refividrio</v-toolbar-title>
    </v-app-bar> 

     <v-navigation-drawer v-model="drawer" absolute temporary>
      <v-list nav dense >
        <v-list-item-group v-model="group">
          <v-list-item @click="menu('/Home')">
            <v-list-item-icon  >
              <v-icon>mdi-home</v-icon>
            </v-list-item-icon>
            <v-list-item-title>Inicio</v-list-item-title>
          </v-list-item>

          <v-list-item>
            <v-list-item-icon>
              <v-icon>mdi-account</v-icon>
            </v-list-item-icon>
            <v-list-item-title>Cuenta</v-list-item-title>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
 

    <!-- <app-menu/> -->
 
    <router-view/>
 
    <app-footer />

  </v-app>
</template>

<script>
 import AppFooter from './components/Footer.vue';
//  import AppMenu from './components/Menu.vue';

  export default {
    data: () => ({
      drawer: false,
      group: null,
    }),
    components: { 
      'app-footer': AppFooter, 
    },
    methods:{
      menu(path){
        if (this.$route.path !== path) 
        this.$router.push(path) 
      }

    }
          // 'app-menu':AppMenu
  }
</script>