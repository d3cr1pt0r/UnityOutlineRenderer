Shader "d3cr1pt0r/Blur"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_BlurAmount("Blur Amount", Float) = 0.0075
	}
	SubShader
	{
		Tags {  }

		// Horizontal blur
		Pass
		{
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment fragment_shader
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _BlurAmount;

			struct vertexInput
			{
				float4 vertex : POSITION;
				fixed2 texcoord : TEXCOORD0;
			};

			struct fragmentInput
			{
				float4 vertex : SV_POSITION;
				fixed2 texcoord : TEXCOORD0;
			};
			
			fragmentInput vertex_shader (vertexInput v)
			{
				fragmentInput o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;

				return o;
			}
			
			fixed4 fragment_shader (fragmentInput i) : SV_Target
			{
				half2 outline_uv = half2(i.texcoord.x, i.texcoord.y);
				float blurAmount = _BlurAmount;

				half4 sum = half4(0,0,0,0);

				sum += tex2D(_MainTex, float2(outline_uv.x - 5.0 * blurAmount, outline_uv.y)) * 0.025;
				sum += tex2D(_MainTex, float2(outline_uv.x - 4.0 * blurAmount, outline_uv.y)) * 0.05;
				sum += tex2D(_MainTex, float2(outline_uv.x - 3.0 * blurAmount, outline_uv.y)) * 0.09;
				sum += tex2D(_MainTex, float2(outline_uv.x - 2.0 * blurAmount, outline_uv.y)) * 0.12;
				sum += tex2D(_MainTex, float2(outline_uv.x - blurAmount, outline_uv.y)) * 0.15;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y)) * 0.16;
				sum += tex2D(_MainTex, float2(outline_uv.x + blurAmount, outline_uv.y)) * 0.15;
				sum += tex2D(_MainTex, float2(outline_uv.x + 2.0 * blurAmount, outline_uv.y)) * 0.12;
				sum += tex2D(_MainTex, float2(outline_uv.x + 3.0 * blurAmount, outline_uv.y)) * 0.09;
				sum += tex2D(_MainTex, float2(outline_uv.x + 4.0 * blurAmount, outline_uv.y)) * 0.05;
				sum += tex2D(_MainTex, float2(outline_uv.x + 5.0 * blurAmount, outline_uv.y)) * 0.025;

				return sum;
			}
			ENDCG
		}

		// Vertical blur
		Pass
		{
			Blend One One
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment fragment_shader
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _BlurAmount;

			struct vertexInput
			{
				float4 vertex : POSITION;
				fixed2 texcoord : TEXCOORD0;
			};

			struct fragmentInput
			{
				float4 vertex : SV_POSITION;
				fixed2 texcoord : TEXCOORD0;
			};
			
			fragmentInput vertex_shader (vertexInput v)
			{
				fragmentInput o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;

				return o;
			}
			
			fixed4 fragment_shader (fragmentInput i) : SV_Target
			{
				half2 outline_uv = half2(i.texcoord.x, i.texcoord.y);
				float blurAmount = _BlurAmount;

				half4 sum = half4(0,0,0,0);

				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y - 5.0 * blurAmount)) * 0.025;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y - 4.0 * blurAmount)) * 0.05;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y - 3.0 * blurAmount)) * 0.09;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y - 2.0 * blurAmount)) * 0.12;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y - blurAmount)) * 0.15;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y)) * 0.16;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y + blurAmount)) * 0.15;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y + 2.0 * blurAmount)) * 0.12;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y + 3.0 * blurAmount)) * 0.09;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y + 4.0 * blurAmount)) * 0.05;
				sum += tex2D(_MainTex, float2(outline_uv.x, outline_uv.y + 5.0 * blurAmount)) * 0.025;

				return sum;
			}
			ENDCG
		}
	}
}