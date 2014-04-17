#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D my_color_texture;

varying vec2 texture_coord;

varying vec3 normal;
varying vec3 vertex_to_light;
varying vec3 vertex_to_camera;


const float specularpower = 25.0;

const float off = 0.005;
const float falloff = 70.0;

void main()
{
  vec4 diffuse_color = vec4(0.0, 0.5, 1.0, 1.0);
  vec4 specular_color = vec4(1.0, 1.0, 1.0, 1.0);


  vec3 n_normal = normalize(normal);

  vec3 n_vertex_to_light = normalize(vertex_to_light);
  float diffuse = clamp (dot (n_normal, n_vertex_to_light), 0.0, 1.0);
  

  vec3 n_vertex_to_camera = normalize(vertex_to_camera);
  vec3 ref = reflect(-n_vertex_to_light, n_normal);

  float specular = clamp(dot (n_vertex_to_camera, ref), 0.0, 1.0);
  specular = pow(specular, specularpower);

  gl_FragColor.xyz = diffuse * diffuse_color.rgb + specular * specular_color.rgb;
  gl_FragColor.a = 1.0;
}