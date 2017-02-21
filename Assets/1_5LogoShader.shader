Shader "Custom/1_5LogoShader" {
	Properties{
		_MainTex("Texture)", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaTest greater 0.1
		pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

 struct v2f {
			float4 pos : SV_POSITION;
			float2 uv :		TEXCOORD0;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
			return o;
		}
		float inFlash(float angle, float2 uv, float xLength, int interval, int beginTime, float offX, float loopTime)
		{
			float brightness = 0;
			float angleInRad = 0.0174444 * angle;
			float currentTime = _Time.y;
			int currentTimeInt = _Time.y / interval;
				currentTimeInt *= interval;

			float currentTimePassed = currentTime - currentTimeInt;
			if (currentTimePassed > beginTime)
			{
				float xBottomLeftBound;
				float xBottomRightBound;

				float xPointLeftBound;
				float xPonitRightBound;

				float x0 = currentTimePassed - beginTime;
				x0 /= loopTime;

				xBottomRightBound = x0;
				xBottomLeftBound = x0 - xLength;

				float xProjL;
				xProjL = (uv.y) / tan(angleInRad);
				xPointLeftBound = xBottomLeftBound - xProjL;
				xPonitRightBound = xBottomRightBound - xProjL;

				xPointLeftBound += offX;
				xPonitRightBound += offX;

				if (uv.x > xPointLeftBound && uv.x < xPonitRightBound)
				{
					float midness = (xPointLeftBound + xPonitRightBound) / 2;
					float rate = (xLength - 2 * abs(uv.x - midness)) / (xLength);
					brightness = rate;
				}
			}
			brightness = max(brightness, 0);

			float4 col = float4(1, 1, 1, 1)*brightness;
			return brightness;
		}
		float4 frag(v2f i) : COLOR
		{
			float4 outp;
		float4 texCol = tex2D(_MainTex, i.uv);

		float tmpBrightness;
		tmpBrightness = inFlash(75.0f, i.uv, 0.25f, 5, 2, 0.15f, 0.7f);

		if (texCol.w > 0.5)
			outp = texCol + float4(1, 1, 1, 1)*tmpBrightness;
		else
			outp = float4(0, 0, 0, 0);
		return outp;
		}
			ENDCG
	  }
	}
}
