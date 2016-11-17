Shader "d3cr1pt0r/OutlineRenderer"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_OutlineTex ("Outline Texture", 2D) = "black" {}
		_Size ("Size", Float) = 0.1
		_BlurAmount("Blur Amount", Float) = 0.0075
		_OutlineColor ("Outline Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags {  }

		// Outline pass1
		Pass
		{
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment fragment_shader
			
			#include "UnityCG.cginc"

			float _Size;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
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

				float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				float2 os = TransformViewToProjection(norm.xy);
				o.vertex.xy += os.xy * o.vertex.z * _Size;

				return o;
			}
			
			fixed4 fragment_shader (fragmentInput i) : SV_Target
			{
				return fixed4(1,1,1,1);
			}
			ENDCG
		}

		// Outline pass2
		Pass
		{
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment fragment_shader
			
			#include "UnityCG.cginc"

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
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
				return fixed4(0,0,0,1);
			}
			ENDCG
		}

		// Background texture + outline texture pass
		Pass
		{
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment fragment_shader
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _OutlineTex;
			float _Size;
			float _BlurAmount;
			fixed4 _OutlineColor;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
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
				fixed4 background = tex2D(_MainTex, i.texcoord);
				fixed4 outline = tex2D(_OutlineTex, fixed2(i.texcoord.x, 1.0 - i.texcoord.y));

				return background + outline * _OutlineColor;
			}
			ENDCG
		}
	}
}