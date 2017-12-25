Shader "Unlit/PointCloudCamera"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_MainTex("Mask (A)", 2D) = "white" {}
		_Size("Size", Float) = 0.1
		_RandomSize("Random Size", Float) = 0.3
		_RandomOffset("Random Offset", Float) = 0.5
	}
		SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
		Blend SrcAlpha One
		//AlphaToMask On
		Cull Off

		Pass
		{
		CGPROGRAM
#pragma vertex vert
#pragma geometry geom
#pragma fragment frag

#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _Size;
			float4 _Color;
			half _RandomSize;
			half _RandomOffset;

			struct GS_INPUT
			{
				float4 vertex : POSITION;
				float3 normal	: NORMAL;
				float4 color	: COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct FS_INPUT {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			GS_INPUT vert(appdata_full v)
			{
				GS_INPUT o = (GS_INPUT)0;
				o.vertex = v.vertex;
				o.normal = v.normal;
				o.color = v.color;
				return o;
			}

			float rand(float3 co, float mult)
			{
				
				return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 45.5432))) * 43758.5453 * mult);
			}
			[maxvertexcount(3)]
			void geom(point GS_INPUT tri[1], inout TriangleStream<FS_INPUT> triStream)
			{
				FS_INPUT pIn = (FS_INPUT)0;
				pIn.normal = mul(unity_ObjectToWorld, tri[0].normal);
				pIn.color = tri[0].color;
				float size = _Size + _RandomSize * rand(tri[0].vertex, _RandomSize);
				float4 vertex = mul(unity_ObjectToWorld, tri[0].vertex) + float4(_RandomOffset * pIn.normal * rand(tri[0].vertex, _RandomOffset), 0);
				
				pIn.vertex = mul(UNITY_MATRIX_VP, vertex) + float4(-size*0.45, 0, 0, 0);
				pIn.texcoord = float2(-0.5,0);
				triStream.Append(pIn);

				pIn.vertex = mul(UNITY_MATRIX_VP, vertex) + float4(0,-size, 0, 0);
				pIn.texcoord = float2(0.5,1.5);
				triStream.Append(pIn);

				pIn.vertex = mul(UNITY_MATRIX_VP, vertex) + float4(size*0.45, 0, 0, 0);
				pIn.texcoord = float2(1.5,0);
				triStream.Append(pIn);
			}

			float4 frag(FS_INPUT i) : COLOR
			{
				float4 color = _Color;
				clip(tex2D(_MainTex, i.texcoord).a -0.5);
				return color;
			}
		ENDCG
		}
	}
}