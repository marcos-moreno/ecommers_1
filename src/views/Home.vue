<template>
 <v-app>
    <app-menu/>
    <v-app-bar color="deep" dark > 
      <v-spacer></v-spacer> 
      <v-text-field @keyup.enter.native="search" v-model="filter" dense flat hide-details rounded solo-inverted ></v-text-field>  
      <v-btn icon  @click="search"><v-icon>mdi-magnify</v-icon> </v-btn>  
      <v-spacer></v-spacer> 
    </v-app-bar> 

    <app-slider v-if="verfiltro == false && page == 1" /> 

    <div class="grey lighten-2"  >
      <v-container class="grey lighten-5">  
          <p v-if="verfiltro == true" style="font-size: 2em;color :#909090">  
          <strong>{{valorBuscado}}</strong> 
          <v-btn text color="error" @click="deleteFilter">X</v-btn>
          </p>{{productos.length}} Resultados
      </v-container>
    </div>

    <v-main class="grey lighten-2" >
      <v-container class="grey lighten-5" style="min-height:556px;"> 
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
          <v-card class="mx-auto my-12" width="260" height="500" @click=seeProduct(producto.value) >
            <center>  
              <v-img  width="230" :src="producto.img" ></v-img>
            </center>
            <v-card-text>
              <div class="my-4 subtitle-3">{{producto.name}}</div>
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
          v-on:input="paginator" 
          v-model="page" 
          :length="lengthPaginator"  
          circle
          :total-visible="7"
          ></v-pagination>
      </div>
    </v-container>      
    </v-main> 
  </v-app> 
</template>  
 
<script>
import AppSlider from '../components/Slider'; 
import config from '../json/config.json'
import axios from 'axios'; 
import AppMenu from '../components/Menu.vue';

export default {
  name: "Productos", 
  props: ['pagina'], 
  data() {
    return { 
      page: 1,
      productos : [],
      productosPaginator : [],
      lengthPaginator:0,
      totalPage:8,
      isLogged : false,
      user : {},
      isLoad : false,
      filter : "",
      valorBuscado : "",
      verfiltro : false
    }; 
  }, 
  components: { 
    'app-slider': AppSlider,
    'app-menu': AppMenu, 
  }, 
  async created() {  
    try{
      if (parseInt(this.pagina) > 0) {
        this.page = parseInt(this.pagina);
      }else{
        this.page = 1;
      }
    }catch (ex){ 
      this.page = 1;
    }
    this.isLoad = true;  
    await this.validaLogin(); 
    await this.allProduct();
    await this.paginator();
    this.isLoad = false;  
  }
  ,methods: {
    async deleteFilter(){
      this.page = 1;
      this.isLoad = true;  
      this.filter = "";
      this.valorBuscado = "";
      this.verfiltro = false;
      await this.allProduct();
      await this.paginator();
      this.isLoad = false;  
    },
    async search(){   
      this.isLoad = true;  
      this.valorBuscado = this.filter.toUpperCase();
      await this.allProduct();
      this.page = 1;
      await this.paginator();
      this.verfiltro = true;
      this.isLoad = false;  
    },
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
      let uri = this.isLogged ? config.apiAdempiere + "/productos/all" : config.apiAdempiere + "/productos/all";
      this.productos = await axios.get(uri
      ,{headers: { 'token': this.$cookie.get('token') },params: {'filter': this.filter === "" ? '' : this.filter}}
      )
      .then(function (response) {  
        if (response.data.status == "success") {
          return response.data.data;
        } else {
          console.log(response.data.data);
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

        let img =  await axios.get(config.apiAdempiere + "/productos/imgByValue"
                  ,{headers: { 'token': this.$cookie.get('token') },params: {filter: element.value}})
        .then(function (response) { 
          if (response.data.status == "success") {
            return response.data.data[0].img;
          } else { 
             return false;
          }
        }).catch(function (response){ 
          console.log(response);
          return false;
        });  
        if (img != false) {
          element.img = 'data:image/jpeg;base64,' + btoa(
            new Uint8Array(img.data)
            .reduce((data, byte) => data + String.fromCharCode(byte), '')
          );
        }else{
          element.img = "../../noImg.png";
        } 
        this.productosPaginator.push(element);
        if (index == fin) {
          this.isLoad = false;   
        }
      } 
      window.scrollTo(0,0);
    },formatMXN(value) {
      var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
      return formatter.format(value);
    },seeProduct(value){  
      this.$router.push('/shop/Product/'+value+'/home/'+ this.page)
    } 
  },
  
}
</script>
