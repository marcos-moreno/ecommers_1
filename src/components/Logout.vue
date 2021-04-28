<template>
  <v-main>
    <v-container class="my-12">  
    </v-container> 
  </v-main> 
</template>

<script> 
  export default {
    name:"Logout", 
    data() {
      return {   
      }
    },
    methods:{ 
    },  
    async mounted() {    
      window.scrollTo(0,0);
    },
    async created(){  
        this.$cookie.set('token',null);  
        location.href = "/";
    }
  }
</script>