<template>
<div>
<app-menu/>
 <v-container class="grey lighten-5" style="min-height:656px;">
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
    <v-container>
      <v-row >
        <v-col cols="12" sm="4">
          <v-btn icon color="blue" @click="returnOrigen"> <v-icon>mdi-arrow-left</v-icon>volver</v-btn>
        </v-col>
        <v-col cols="12" sm="8" >
          <!-- <v-btn icon color="blue" @click="returnOrigen"> <v-icon>mdi-arrow-left</v-icon>volver</v-btn> -->
        </v-col>
      </v-row>
    </v-container>
   
    <div v-if="productoEncontrado && isLoad == false" style="min-height: 600px;">
      <v-row v-if="agregado==false" no-gutters >
        <v-col>
          <v-card  >  
          <center>  
            <v-img width="400px" v-if="producto.img=='/noImg.png' || isMobile()"  :src="producto.img"></v-img>
            <zoom-on-hover :scale="2"  v-else width="400px" :img-normal="producto.img">
            </zoom-on-hover> 
          </center>
          <v-card-title>{{producto.name}}</v-card-title>
          <v-card-subtitle class="pb-0">
              {{producto.description}}
          </v-card-subtitle>
          <v-simple-table>
            <template v-slot:default>
              <thead>
                <tr>
                  <th class="text-left">DISP.</th>
                  <th class="text-left">PRECIO</th>
                  <th class="text-left">UNIDAD</th>
                  <th class="text-left">CÓDIGO</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>{{producto.mex_quantytotal}}</td>
                  <td>{{formatMXN(producto.l0)}}</td>
                  <td>{{producto.unidad}}</td>
                  <td>{{producto.value}}</td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>  
          </v-card>
        </v-col>
        <v-col > 
          <template> 
            <v-container >
              <v-row>
                <v-col  class="justify-center">
                  <div>Cantidad de la compra   
                    <v-row>
                      <v-col>
                        <center>
                          <v-text-field class="centered-input text--darken-3 mt-3" style="width:300px" 
                            v-model="qty" type="number" label="Cantidad"
                            append-outer-icon="mdi-plus" @click:append-outer="qtyMovement('+')" 
                            prepend-icon="mdi-minus" @click:prepend="qtyMovement('-')" 
                            v-on:keyup="qtyMovement('0')" @click="qtyMovement('0')" 
                            onkeydown="javascript: return event.keyCode == 69 ? false : true" 
                          ></v-text-field>
                          <p style="font-size: 0.9em; color:#909090">
                            {{producto.mex_quantytotal}} disponible
                          </p>
                        </center>
                       
                      </v-col>
                    </v-row> 
                  </div>   
                  
                  <div class="font-black text-center" style=" font-size: 0.8em;">{{formatMXN(producto.l0)}} c/u.</div>
                  <p class="font-black text-center" style=" font-size: 1.8em;">{{calculaTotalProd}}</p>
                  <center>
                    <div v-if="producto.mex_quantytotal < qty" class="font-weight-thin-black" style="font-size: 0.8em; color:#F72D04"> 
                      <div v-if="((producto.mex_quantytotal - qty)*-1)==1">
                        No hay stock disponible, se agregará 1 pz en forma de pedido.
                      </div>
                      <div v-else>
                        No hay stock disponible, se agregarán <strong>{{(producto.mex_quantytotal - qty)*-1}}</strong> pzs en forma de pedido.
                      </div>
                    </div>  
                  </center>
                  <br>
                  <v-card-actions>
                    <v-btn class="mx-auto white--text" width="100%" large color="primary" @click="addtocar"  >
                      Agregar Al Carrito
                    </v-btn>      
                  </v-card-actions>      
                  <v-alert v-if="msgErro!=''" dense outlined type="error" >
                    {{msgErro}}
                  </v-alert>
                </v-col>
              </v-row> 
            
            </v-container> 
          </template> 
        </v-col> 
         
        <v-row class="my-5" v-if="producto.elements!=null&&producto.elements!=''">
          <v-card
              class="mx-auto"
              outlined
            > 
              <v-list-item three-line>
                <v-list-item-content>
                  <div class="overline mb-4">
                    <strong>Descripción del producto</strong>
                  </div>
                  <div >
                    <p v-html="producto.elements"></p>  
                  </div>
                </v-list-item-content> 
              </v-list-item>  
            </v-card> 
        </v-row>  
      </v-row> 
      <v-row v-else no-gutters class="my-12 mx-auto">
          <v-container  style="min-height:556px;"  >
          <div >
            <v-card style="min-height:186px;"> 
              <v-row>
                <v-col cols="12" sm="6" md="2"> 
                  <v-img width="200px" :src="producto.img"></v-img>
                </v-col>
                <v-col cols="12" sm="6" md="6">
                  <div class="my-5" style="font-size: 1em;color :#00A6FF">  
                    <v-icon style=" color: green;">mdi-checkbox-marked-circle</v-icon> AGREGASTE A TU CARRITO 
                  </div>
                  <div  style="font-size: 1em;">  
                  {{ producto.name }}
                  </div>  
                </v-col>
                <v-col>
                    <br>
                    <v-card-actions>
                      <v-btn class="mx-auto white--text" width="100%" large color="primary" @click="menu('/shop/shopingcar/')" >
                        Ver carrito
                      </v-btn>  
                    </v-card-actions>
                </v-col>
              </v-row> 
            </v-card> 
          </div>  
        </v-container>
      </v-row>  
    </div>
    <div v-if="isLoad == false && productoEncontrado==false" >
      <v-container class="mx-auto text-center" style="min-height:706px;">
        <br><br><br>
        <img width="280" src="../../public/error.gif">
        <p style="font-size: 2em;color :#909090">  
          <strong>El producto que buscas no esta disponible.</strong> 
        </p>
      </v-container>
    </div>
    <v-spacer class="my-12"></v-spacer> 
  </v-container>
  </div>
</template>


<style scoped>
  .centered-input >>> input {
    text-align: center
  }
</style>

<script>
import axios from 'axios'; 
import config from '../json/config.json'
import AppMenu from '../components/Menu.vue';

export default {
  name:"appProducto",
  props: ['value','origen','pagina'], 
  data() {
    return { 
      qty : 1
      ,producto : {value:0}
      ,user:{}
      ,isLogged:false
      ,isLoad:false
      ,agregado : false
      ,productoEncontrado: false
      ,msgErro:''
    }
  },
  components: { 
      'app-menu': AppMenu, 
  },
  async mounted() {    
    window.scrollTo(0,0);
  }, 
  async created(){ 
    this.isMobile();
    this.isLoad = true;
    await this.validaLogin(); 
    await this.getProduct();
    this.isLoad = false;
  },
  methods:{
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
    returnOrigen(){
        if (this.origen == "home") {
          this.menu("/shop/"+this.origen+'/'+this.pagina);
        }else{
          this.menu("/shop/"+this.origen+'/');
        }
    },
    async cantidadCar(){
        await axios.get(config.apiAdempiere + "/shopingcar/get_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{
          if(res.data.status == "success"){ 
            document.getElementById("cantidadInCar").value = res.data.data.length;
            return res.data; 
          }  
        })
        .catch(err=>{return err;});   
    },
    menu(path){
        if (this.$route.path !== path){
        this.$router.push(path);
        }  
    }, 
    async addtocar(){  
        this.isLoad = true;
        if (this.isLogged) {
          if (this.isInt(this.qty) && this.qty > 0) { 
            this.agregado = await axios.post(config.apiAdempiere + "/shopingcar/add_auth", 
            {value: this.producto.value, cantidad : this.qty},{headers:{'token': this.$cookie.get('token')}})
            .then(res=>{ 
              if(res.data.status == "success"){ 
                return true;
              }else{
                console.log(res.data.status);
                return false;
              } 
            }).catch(err=>{
              console.log(err);
              return false;
            });  
            if (this.agregado) { 
              this.cantidadCar();
            }
            this.msgErro = '';
            window.scrollTo(0,0);  
          }else{
            this.msgErro = "Ingresa una cantidad válida."
          }
        } else {
            this.menu('/shop/Login/');
        }
        this.isLoad = false; 
    },
    isInt(value) {
        var x;
        return isNaN(value) ? !1 : (x = parseFloat(value), (0 | x) === x);
    },
    async qtyMovement(vl){ 
        try {
          if (this.isInt(this.qty)) {

            if (vl == '+') {
              this.qty  = parseInt(this.qty) + 1;
            }else  if (vl == '-') {
              if ( parseInt(this.qty)  > 1) {
                  this.qty =  parseInt(this.qty)  - 1;
              }
            } 
            if (this.qty < 0) {
             this.qty = this.qty * -1;
            } 
          }else{
            if (this.qty != "") {
              this.qty = 0;
            }
          }  
        } catch (error) { 
          console.log(error);
          this.qty = 1;
        }  
    },
    async getProduct(){
      try {
        let uri = "/productos/all";
        uri = config.apiAdempiere + uri; 
        this.producto = await axios.get(uri
        ,{headers: { 'token': this.$cookie.get('token') },params: {filter: this.value}})
        .then(function (response) { 
          return response.data;
        }).catch(function (response){  
          return response;
        });  
        if (this.producto.status == "success") {
            this.producto = this.producto.data;   
          if (this.producto.length > 0) {
              this.producto = this.producto[0];  
              try {
                let img = await axios.get(config.apiAdempiere + "/productos/imgByValue"
                      ,{headers: { 'token': this.$cookie.get('token') },params: {filter: this.value}})
                      .then(function (response) {  
                        return response.data.data;
                      }).catch(function (response){  
                        console.log(response);
                        return response;
                      }); 
                    if (img.length == 1) {
                      img = img[0].img;
                      this.producto.img = 'data:image/jpeg;base64,' + btoa(
                          new Uint8Array(img.data)
                      .reduce((data, byte) => data + String.fromCharCode(byte), '')
                      );  
                    }else{ 
                      this.producto.img = "/noImg.png";
                    }
                 
              } catch (error) {
                 this.producto.img = "/noImg.png";
              } 
            this.productoEncontrado = true; 
          }  
        } else {
          this.productoEncontrado = false; 
        } 
      } catch (error) {
        this.productoEncontrado = false; 
      }
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
        let inputCar = document.getElementById("cantidadInCar");
        if (inputCar != null) {
          inputCar.value = "";
        }
      } 
    },
    formatMXN(value) {
          var formatter = new Intl.NumberFormat('es-MX', {style: 'currency', currency: 'MXN',});
          return formatter.format(value);
    } 
  },
  computed:{  
    calculaTotalProd(){
      let total = 0;
        total = this.producto.l0 * this.qty;
      return this.formatMXN(total);
    },
  },

}
</script>