uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//in vec3 VertexPosition; 
//in vec3 VertexColor; 
//out vec3 Color; 
void main() {     
	Color = VertexColor;     
	gl_Position = vec4( VertexPosition, 1.0 ); 
}