#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//uniform vec2 resolution;
uniform sampler2D texture;

//uniform float time;


void main(void) {
  vec2 p = gl_FragCoord.xy / resolution.xy;
 
  float darkness = 0.85;
  vec2 textureCoords = p - 0.5;
  float vignette = 1.0 - (dot(textureCoords, textureCoords) * darkness);
  
  vec3 bgcolor;
  bgcolor.r =   vignette * mix(355./255., 220./255.,  p.y + .25 );
  bgcolor.g = vignette * mix(145./255.,  220./255., p.y  + .25);
  bgcolor.b =  vignette * mix(100./255., 210./255., p.y  + .25);
  //bgcolor.a = 1.0;
  
  //noise
  float x = p.x * p.y * time *  1000.0;
  x = mod( x, 13.0 ) * mod( x, 123.0 );
  float dx = mod( x, 0.01 );
  //vec4 tex = texture2D(texture, gl_TexCoord[0].xy); 
  vec4 tex = vec4(1.,1.,1.,1.);
  vec3 cResult = tex.rgb + tex.rgb * clamp( 0.1 + dx * 100.0, 0.0, 1.0 );
  float nIntensity = .13; 
 
  cResult = tex.rgb + clamp( nIntensity, 0.0,1.0 ) * ( cResult - tex.rgb );

 gl_FragColor = vec4(cResult * bgcolor, 1.0) ; 
}