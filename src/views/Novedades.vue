<template> 
  <div>
    <app-menu/>    

    <div style="min-heigth:40px;">
      <v-carousel hide-delimiters height="100%"> 
        <v-carousel-item  > 
            <v-img src="../../public/bannernovedada.png" height="100%" width="100%"></v-img>
        </v-carousel-item>
      </v-carousel>
      <!-- <v-carousel  v-model="indexSlider" hide-delimiters height="100%"> 
        <v-carousel-item v-for="(item,i) in bannerNovedades" :key="i"  > 
            <v-img contain :src="item.src" height="100%" width="100%"></v-img>
        </v-carousel-item>
      </v-carousel>  -->
    </div>  

    <center class="my-5"><h1>Novedades</h1></center>
    <v-row class="lighten-1" > 
      <v-col cols="12" sm="2"></v-col>  
      <v-col cols="12" sm="8" class="grey lighten-5"> 
         <v-carousel hide-delimiters height="900"> 
        <v-carousel-item  > 
             <zoom-on-hover :scale="1" width="400px"
            :img-normal="`../bannnerAir.jpg`">
          </zoom-on-hover> 
        </v-carousel-item>
         <v-carousel-item  >  
           <zoom-on-hover :scale="1" width="400px"
            :img-normal="`../bannnerAir2.jpg`">
          </zoom-on-hover>
        </v-carousel-item>
      </v-carousel> 
         
          <v-row class="mb-6" no-gutters >    
              <div class="text-center">
                  <v-dialog v-model="isLoad" persistent width="300">
                  <v-card color="primary" dark >
                      <v-card-text>
                          cargando
                      <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear>
                      </v-card-text>
                  </v-card> 
                  </v-dialog>
              </div>  
              <v-col v-for="producto in productosPaginator" :key="producto.value"> 
                  <v-card class="mx-auto my-3" width="260" height="500" @click="seeProduct(producto.value)" >
                  <center>   
                      <v-img :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" :lazy-src="`../../public/noImg.png`"
                              aspect-ratio="1" class="grey lighten-2" width="220" height="170"> 
                      <template v-slot:placeholder>
                          <v-row class="fill-height ma-0" align="center" justify="center">
                          <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                          </v-row>
                      </template> 
                      </v-img>
                  </center>
                  <v-card-text>
                      <div class="my-4 subtitle-3">{{producto.name.substring(0,83)}}</div>
                      <div class="my-4 subtitle-2">{{producto.value}}</div>
                  </v-card-text> 
                  <v-divider class="mx-4">Costos</v-divider>
                  <v-card-title >
                      {{ formatMXN(producto.l0) }}
                  </v-card-title>
                  <v-card-text>
                      <div class="my-4 subtitle-1">
                      Cantidad Disponible: {{ producto.mex_quantytotal }}
                      </div> 
                  </v-card-text> 
                  </v-card> 
              </v-col> 
          </v-row>   
          <div class="text-center">
            <v-pagination 
                v-if="productosPaginator.length > 0" v-on:input="paginator" 
                v-model="page" :length="lengthPaginator" circle :total-visible="7">
            </v-pagination>
          </div>  
          <br> 
      </v-col>
      <v-col cols="12" sm="2"> 
      </v-col>
    </v-row>      
  </div>
 
</template>  
 
<script> 
import config from '../json/config.json'
import axios from 'axios'; 
import AppMenu from '../components/Menu.vue';

export default {
  name: "Novedades",  
  data() {
    return { 
      page: 1,
      filter : "", 
      productos : [],
      productosPaginator : [],
      lengthPaginator:0,
      totalPage:8,
      isLogged : false,
      user : {},
      isLoad : false, 
      bannerNovedades: 
        [
            // {src: '../novedad1.jpg',},
            // {src: '../novedad2.jpg',}, 
            {src: '../../public/bannernovedada.png',}, 
            
        ],  
    }; 
  }, 
  components: {  
    'app-menu': AppMenu, 
  }, 
  async created() {    
    this.isLoad = true;  
    await this.validaLogin();
    await this.allProduct();  
    await this.paginator(); 
    this.isLoad = false;   
  } 
  ,methods: {    
    async validaLogin(){
      this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
      {'headers': { 'token': this.$cookie.get('token') }})
      .then(res=>{return res.data;})
      .catch(err=>{return err;});    
      if (this.user.status == "success") {
        this.user = this.user.user; 
        this.isLogged = true;
      }else if(this.user.status == "unauthorized"){ 
        this.isLogged = false;
      }  
    }
    ,async allProduct(){  
      this.productos = [];
      this.productosPaginator = [];
      let uri = config.apiAdempiere + "/productos/novedades";
      this.productos = await axios.get(uri
      ,{
        headers: { 'token': this.$cookie.get('token') },
        params: {}
      }
      ).then(function (response) {  
        if (response.data.status == "success") {
          return response.data.data;
        } else {
          console.log(response);
          return [];
        }
      }).catch(function (response){ 
        console.log(response);
        return [];
      });  
      this.lengthPaginator = Math.ceil(this.productos.length/this.totalPage); 
    } 
    ,async paginator(){   
      this.isLoad = true; 
      this.productosPaginator = [];
      let fin = ((this.page * (this.totalPage )) -1) > (this.productos.length -1) ? (this.productos.length -1):((this.page * (this.totalPage )) -1);  
    
      for (let index = ( ( (this.page -1) * this.totalPage)); index <= fin; index++) {
        let element = this.productos[index];    
        this.productosPaginator.push(element);
        if (index == fin) {
          this.isLoad = false;
          window.scrollTo(0,0);
        }
      } 
      window.scrollTo(0,0);
    },formatMXN(value) {
      var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
      return formatter.format(value);
    },seeProduct(value){   
      this.$router.push(`/shop/Product/${value}/Novedades/${this.page}`);
    } 
  },
  
}
</script>
