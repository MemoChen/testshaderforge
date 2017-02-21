Shader "Custom/1_2show1texture" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
		SubShader{
		Pass{
		Material{
		Diffuse[_Color]
			   }
		Lighting on
		SetTexture[_MainTex]
	       {
		Combine texture * primary,texture * constant
           }
		}
	}
}
