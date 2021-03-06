// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "URun/Falling Platform Dissolvement"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _DissMap("Dissolvement Map", 2D) = "white" {}
        _DissAmo("Dissolvement Amount", Range(0.0, 1.0)) = 1.0
        _Strength ("Border Strength", Range(0.0, 0.2)) = 0.05
        _Tint ("Border Tint", COLOR) = (1.0, 1.0, 1.0, 1.0)
    }
    
    SubShader
    {
        Tags 
        {
            "Queue" = "Transparent"
        }
        
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            CGPROGRAM
            
            //pragmas
            #pragma vertex vert
            #pragma fragment frag
            
            //includes
            #include "UnityCG.cginc"
            
            //Variablen deklarationen
            sampler2D _MainTex;
            sampler2D _DissMap;
            float4 _Tint;
            float _Strength;
            float _DissAmo;
            
            //structs
            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct fragmentInput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            //functions
            
            //frag and vert
            fragmentInput vert (vertexInput i)
            {
                fragmentInput o;
                
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.uv = i.uv;
                
                return o;
            }
            
            fixed4 frag (fragmentInput i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                float dissolvement = (color.a - tex2D(_DissMap, i.uv).r) - _DissAmo;
                
                if(dissolvement > _Strength || _DissAmo == 0.0)
                    discard;
                else if(dissolvement > 0.0)
                    color = _Tint;
                
                return color;
            }
            
            ENDCG
        }
    }
}
