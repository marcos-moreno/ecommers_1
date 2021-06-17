<template>
 <v-app>
    <app-menu/>
    <v-app-bar color="deep" dark > 
      <v-spacer></v-spacer> 
      <v-text-field @keyup.enter.native="search" v-model="filter" dense flat hide-details rounded solo-inverted ></v-text-field>  
      <v-btn icon  @click="search"><v-icon>mdi-magnify</v-icon> </v-btn>  
      <div v-if="!isMobile()"> 
        <v-container fluid>
          <v-row align="center">  
            <v-col >
              <v-btn style="margin:50px" @click="showFilter('filter')">
                <img src="../../public/filtro.svg" width="15px" style="margin:5px" />filtrar
              </v-btn>
            </v-col> 
            <v-col>
              <v-select style="width:150px;height:40px" v-model="orden" @change="applyFilter()"
                :items="['Menor precio', 'Mayor precio', 'Más vendido']" 
                label="Ordenar por" >
              </v-select>
            </v-col> 
          </v-row>
        </v-container>   
      </div>
      <v-spacer></v-spacer> 
    </v-app-bar>
     
    <v-app-bar color="deep" dark v-if="isMobile()">  
      <v-container>
        <v-row>
          <v-col>
            <v-btn @click="showFilter('filter')" >
              <img src="../../public/filtro.svg" width="15px" style="margin:5px" />filtrar
            </v-btn>
          </v-col>
          <v-col>
            <!-- <v-btn @click="showFilter('order')">  
              <img src="../../public/ordenar.svg" width="15px" style="margin:5px"  />Ordenar
            </v-btn> -->
              <v-select style="width:150px;height:40px" v-model="orden" @change="applyFilter()"
                :items="['Menor precio', 'Mayor precio', 'Más vendido']" 
                label="Ordenar por" >
              </v-select>
          </v-col>  
        </v-row>
      </v-container> 
    </v-app-bar> 

    <v-navigation-drawer v-model="sceemFiltro" absolute temporary width="300px">
      
        
        <v-list nav dense >
          <v-list-item-group>
              <!-- Inicio filtro -->
              <div v-if="typeScreem=='filter'">
                <v-list-item class="px-2">
                <v-list-item-title  @click.stop="sceemFiltro = !sceemFiltro">
                  <h1>Filtrar por</h1>
                </v-list-item-title> 
                <v-btn icon  @click.stop="sceemFiltro = !sceemFiltro"> 
                  <v-icon>mdi-chevron-right</v-icon>
                </v-btn>
              </v-list-item>
                <v-list-item> 
                    <v-list-item>
                        <v-container class="px-0" fluid>
                          <v-switch @change="filterOnlystock()" v-model="onlystock" label="Solo producto con existencia." ></v-switch>
                        </v-container> 
                    </v-list-item> 
                </v-list-item>   
                
                <v-list-item-title> 
                  <v-card flat color="transparent">
                    <v-list-item-title>Precio</v-list-item-title> 
                    <v-card-text>
                      <v-row>
                        <v-col class="px-4">
                          {{formatMXN(range[0])}}  -- {{formatMXN(range[1])}}
                          <v-range-slider v-model="range" @change="movementPriceFilter()"  :max="max" :min="min" hide-details class="align-center" >
                            <template v-slot:prepend>
                              <v-text-field  style="display:none;" :value="range[0]"  type="number" @change="$set(range, 0, $event)"></v-text-field>
                            </template>
                            <template v-slot:append style="">
                              <v-text-field  style="display:none;" :value="range[1]"  type="number" @change="$set(range, 1, $event)"></v-text-field>
                            </template>
                          </v-range-slider>
                        </v-col>
                      </v-row>
                    </v-card-text>
                  </v-card>  
                </v-list-item-title>

                <!-- <v-list-item>  -->
                <v-list-item-title>
                <v-card flat color="transparent">
                      <v-checkbox @change="applyFilter()" v-model="isfilterAndalucia"  label="Aromas de Andalucía"></v-checkbox>
                      <v-checkbox @change="applyFilter()" v-model="isfilterLD" label="Air Natur Home"></v-checkbox>
                </v-card> 
                </v-list-item-title>
              </div>
              <!-- Fin filtro -->
              <v-list-item-title>
                <div v-if="typeScreem=='order'">
                  <v-list-item class="px-2">
                    <v-list-item-title  @click.stop="sceemFiltro = !sceemFiltro">
                      <h1>Ordenar por</h1>
                    </v-list-item-title> 
                    <v-btn icon  @click.stop="sceemFiltro = !sceemFiltro"> 
                      <v-icon>mdi-chevron-right</v-icon>
                    </v-btn>
                  </v-list-item>  
                </div>
              </v-list-item-title>
          
          </v-list-item-group> 
        </v-list>
      </v-navigation-drawer> 

    <app-slider v-if="verfiltro == false && page == 1" /> 

    <div class="grey lighten-2"  >
      <v-container class="grey lighten-5">  
          <p v-if="verfiltro == true && valorBuscado != ''" style="font-size: 2em;color :#909090">  
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
              <!--  :src="producto.img" 
                src="../../public/noImg.png" 
                :src="`https://picsum.photos/500/300?image=15`" 
              -->
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
      ordenMenorP : false,
      ordenMayorP : false,
      ordenMasVendido : false,
      orden : null,
      isfilterAndalucia:true,
      isfilterLD:true,
      min: 0,
      max: 5000,
      range: [0, 5000],
      maxProd : 0,
      minProd : 0,
      // isMobile : null,
      onlystock : false,
      sceemFiltro : false,
      typeScreem:null,
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
      verfiltro : false,
      productosFiltrados : []
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
    this.getExtremos();
    await this.paginator();
    this.isLoad = false;  
  } 
  ,methods: { 
    getExtremos(){
      for (let index = 0; index < this.productos.length; index++) {
        const element = this.productos[index]; 
        if (index == 0) {
            this.min = element.l0;
            this.max = element.l0; 
        }
        if (parseFloat(this.max) < parseFloat(element.l0)){
          this.max = parseInt(element.l0);
        }
        if (parseFloat(element.l0) < parseFloat(this.min))
        { 
          this.min = parseInt(element.l0);
        }
      }  
      this.range = [this.min, this.max]; 
    },
    async applyFilter(){
      this.ordenMenorP = false;
      this.ordenMayorP = false;
      this.ordenMasVendido = false;
      switch (this.orden) {
        case 'Menor precio': 
          this.ordenMenorP = true; 
          break;
        case 'Mayor precio':  
          this.ordenMayorP = true; 
          break;
        case 'Más vendido':  
          this.ordenMasVendido = true;
          break;  
      }
      this.isLoad = true;   
      await this.allProduct();
      this.page = 1;
      await this.paginator();
      this.verfiltro = true;
      this.sceemFiltro = false;
      this.isLoad = false;   
    },
    movementPriceFilter(){
      this.applyFilter();
    },
    async filterOnlystock(){
      this.applyFilter();
    },
    showFilter(value){ 
      this.typeScreem = value;
      this.sceemFiltro = true;
    },
    isMobile(){
      if( navigator.userAgent.match(/Android/i)
        || navigator.userAgent.match(/webOS/i)
        || navigator.userAgent.match(/iPhone/i)
        || navigator.userAgent.match(/iPad/i)
        || navigator.userAgent.match(/iPod/i)
        || navigator.userAgent.match(/BlackBerry/i)
        || navigator.userAgent.match(/Windows Phone/i)){
          return true;
        }else{
          return false;
        }
    },
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
      let uri = config.apiAdempiere + "/productos/all";
      this.productos = await axios.get(uri
      ,{
        headers: { 'token': this.$cookie.get('token') },
        params: {
            filter: this.filter
            ,onliStock : this.onlystock
            ,range : this.range
            ,andalucia : this.isfilterAndalucia 
            ,ld : this.isfilterLD 
            ,ordenMenorP : this.ordenMenorP
            ,ordenMayorP : this.ordenMayorP
            ,ordenMasVendido : this.ordenMasVendido
        }
      }
      ).then(function (response) { 
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
    },imageExists(image_url){

    var http = new XMLHttpRequest();

    http.open('HEAD', image_url, false);
    http.send();

    return http.status != 404;

    }
    ,async paginator(){   
      this.isLoad = true; 
      this.productosPaginator = [];
      let fin = ((this.page * (this.totalPage )) -1) > (this.productos.length -1) ? (this.productos.length -1):((this.page * (this.totalPage )) -1);  
      for (let index = ( ( (this.page -1) * this.totalPage)); index <= fin; index++) {
        let element = this.productos[index];   

        // let img =  await axios.get(config.apiAdempiere + "/productos/imgByValue"
        //           ,{headers: { 'token': this.$cookie.get('token') },params: {filter: element.value}})
        // .then(function (response) { 
        //   if (response.data.status == "success") {
        //     return response.data.data[0].img;
        //   } else { 
        //      return false;
        //   }
        // }).catch(function (response){ 
        //   console.log(response);
        //   return false;
        // });  
        // if (img != false) {
        //   element.img = 'data:image/jpeg;base64,' + btoa(
        //     new Uint8Array(img.data)
        //     .reduce((data, byte) => data + String.fromCharCode(byte), '')
        //   );
        // }else{
        //   element.img = "../../noImg.png";
        // } 
        // element.img ="https://http2.mslstatic.com/D_NQ_NP_752ssss603-MLM32631339298_102019-O.webp" ;
         

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
      this.$router.push('/shop/Product/'+value+'/home/'+ this.page)
    } 
  },
  
}
</script>
