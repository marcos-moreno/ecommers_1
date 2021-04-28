<template>
  <v-container class="grey lighten-5">
    <v-row class="mb-6" no-gutters> 
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
          <v-img  width="230" :src="producto.img" ></v-img>
          <v-card-text>
            <div class="my-4 subtitle-3">{{producto.name}}</div>
          </v-card-text> 
          <v-divider class="mx-4">Costos</v-divider>
          <v-card-title >
            $ {{ producto.l0 }}
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
</template>

<script>
import config from '../json/config.json'
import axios from 'axios'; 
export default {
  name: "CrudDepartment",
  data() {
    return { 
      page: 1,
      productos : [],
      productosPaginator : [],
      lengthPaginator:0,
      totalPage:12,
      isLogged : false,
      user : {},
      isLoad : false
    }; 
  }, 
  async created() {  
    this.isLoad = true;  
    await this.validaLogin(); 
    await this.allProduct();
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
      let uri = this.isLogged ? config.apiAdempiere + "/productos/allByListPrice_auth" : config.apiAdempiere + "/productos/all";
      this.productos = await axios.get(uri,{'headers': { 'token': this.$cookie.get('token') }})
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
      for (let index = 0; index < this.productos.length; index++) {
        let element = this.productos[index];  
        if (index < this.totalPage) {
          let img = await axios.get(config.apiAdempiere + "/productos/imgByValue?value="+element.value)
          .then(function (response) { 
            if (response.data.status == "success") {
              return response.data.data[0].img;
            } else {
              console.log(response.data.data);
              return "";
            }
          }).catch(function (response){ 
            console.log(response);
            return "";
          });   
          element.img = 'data:image/jpeg;base64,' + btoa(
              new Uint8Array(img.data)
              .reduce((data, byte) => data + String.fromCharCode(byte), '')
          );    
          this.productosPaginator.push(element);   
        }
      }  
    }
    ,async paginator(){ 
      this.isLoad = true; 
      this.productosPaginator = [];
      let fin = ((this.page * (this.totalPage )) -1) > (this.productos.length -1) ? (this.productos.length -1):((this.page * (this.totalPage )) -1);  
      for (let index = ( ( (this.page -1) * this.totalPage)); index <= fin; index++) {
        let element = this.productos[index];   
        let img = await axios.get(config.apiAdempiere +"/productos/imgByValue"
        ,{params: {value:element.value}}
        )
        .then(function (response) { 
          if (response.data.status == "success") {
            return response.data.data[0].img;
          } else {
            console.log(response.data.data);
            return "";
          }
        }).catch(function (response){ 
          console.log(response);
          return "";
        });   
        element.img = 'data:image/jpeg;base64,' + btoa(
            new Uint8Array(img.data)
            .reduce((data, byte) => data + String.fromCharCode(byte), '')
        );
        this.productosPaginator.push(element);
        if (index == fin-1) {
          this.isLoad = false;   
        }
      } 
      window.scrollTo(0,0);
    }
    ,seeProduct(value){
      this.$router.push('/shop/Product/'+value) 
    } 
  },
  
}
</script>
