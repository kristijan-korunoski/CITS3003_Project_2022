// Kristijan Korunoski - 22966841
// Luke Kirkby - 22885101

attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec3 pos;
varying vec3 varN;
//varying vec4 color;

// Task G comments
//uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
//uniform vec4 LightPosition;
//uniform float Shininess;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    pos = (ModelView * vpos).xyz;

    // Task G start commenting
    /*
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Task F
    float distance = sqrt(Lvec[0]*Lvec[0] + Lvec[1]*Lvec[1] + Lvec[2]*Lvec[2]);
    float scaleDist = 1.0/(distance*distance);

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    */
    varN = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );
    /*
    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    // Task F
    color.rgb = globalAmbient + scaleDist*(ambient + diffuse + specular);
    color.a = 1.0;
    */

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
