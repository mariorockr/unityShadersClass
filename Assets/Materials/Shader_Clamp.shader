Shader "Unlit/Shader_Clamp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex ("Texture", 2D) = "white" {}
        _XValue ("X", Range(0,1)) = 0
        _AValue ("A", Range(0,1)) = 0
        _BValue ("B", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _SecondTex;
            float4 _MainTex_ST;
            float4 _SecondTex_ST;
            float _XValue;
            float _AValue;
            float _BValue;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //float darkness = clamp(_AValue, _XValue, _BValue);
            //    fixed4 col = tex2D(_MainTex, i.uv) * darkness ;
                
                
                fixed4 col = tex2D(_MainTex, i.uv) ;
                fixed4 col2 = tex2D(_SecondTex, i.uv) ;
                fixed4 selectedTex = col * (1.0 - _XValue) + col2 * _XValue;
                selectedTex = clamp(selectedTex, 0 , 1);
                
                
                UNITY_APPLY_FOG(i.fogCoord, selectedTex);
                return selectedTex;
            }
            ENDCG
        }
    }
}
