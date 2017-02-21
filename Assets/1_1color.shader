Shader "Custom/1_1color" {
	Properties{
		_Color("Main Color",Color) = (1,1,1,1)
	}
		SubShader{
			Pass {
			Material {
			Diffuse[_Color]
		}
		lighting On
		}
	}
}
