-- ReparagymStore Database Schema
-- PostgreSQL 15+ with Medusa.js Extensions
-- Mexican Market E-commerce for Gym Equipment Parts
-- Generated: September 20, 2025

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For fuzzy text search
CREATE EXTENSION IF NOT EXISTS "unaccent"; -- For accent-insensitive search

-- ================================================================
-- CORE MEDUSA.JS SCHEMA EXTENSIONS
-- ================================================================

-- Enhanced customer table for Mexican B2B market
ALTER TABLE customer ADD COLUMN IF NOT EXISTS company_name VARCHAR(255);
ALTER TABLE customer ADD COLUMN IF NOT EXISTS phone VARCHAR(20);
ALTER TABLE customer ADD COLUMN IF NOT EXISTS phone_verified BOOLEAN DEFAULT false;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS email_verified BOOLEAN DEFAULT false;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS email_verified_at TIMESTAMP;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS account_type VARCHAR(20) DEFAULT 'business';
ALTER TABLE customer ADD COLUMN IF NOT EXISTS terms_accepted_at TIMESTAMP;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS data_consent_at TIMESTAMP;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS failed_login_attempts INTEGER DEFAULT 0;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS locked_until TIMESTAMP;
ALTER TABLE customer ADD COLUMN IF NOT EXISTS preferred_language VARCHAR(5) DEFAULT 'es';

-- Enhanced product table for gym equipment parts
ALTER TABLE product ADD COLUMN IF NOT EXISTS brand_id UUID REFERENCES brand(id);
ALTER TABLE product ADD COLUMN IF NOT EXISTS machine_type_id UUID REFERENCES machine_type(id);
ALTER TABLE product ADD COLUMN IF NOT EXISTS compatibility_tags TEXT[];
ALTER TABLE product ADD COLUMN IF NOT EXISTS weight_kg DECIMAL(8,2);
ALTER TABLE product ADD COLUMN IF NOT EXISTS dimensions_cm INTEGER[3]; -- Length, Width, Height
ALTER TABLE product ADD COLUMN IF NOT EXISTS spanish_title VARCHAR(255);
ALTER TABLE product ADD COLUMN IF NOT EXISTS spanish_description TEXT;
ALTER TABLE product ADD COLUMN IF NOT EXISTS technical_specs JSONB;
ALTER TABLE product ADD COLUMN IF NOT EXISTS country_of_origin VARCHAR(3) DEFAULT 'US';
ALTER TABLE product ADD COLUMN IF NOT EXISTS hs_code VARCHAR(20); -- For customs/import

-- Enhanced product variant table
ALTER TABLE product_variant ADD COLUMN IF NOT EXISTS sku_barcode VARCHAR(50);
ALTER TABLE product_variant ADD COLUMN IF NOT EXISTS attributes JSONB;
ALTER TABLE product_variant ADD COLUMN IF NOT EXISTS spanish_title VARCHAR(255);
ALTER TABLE product_variant ADD COLUMN IF NOT EXISTS spanish_description TEXT;
ALTER TABLE product_variant ADD COLUMN IF NOT EXISTS lead_time_days INTEGER DEFAULT 7;
ALTER TABLE product_variant ADD COLUMN IF NOT EXISTS min_order_quantity INTEGER DEFAULT 1;

-- Enhanced region table for Mexico
ALTER TABLE region ADD COLUMN IF NOT EXISTS tax_rate DECIMAL(5,4) DEFAULT 0.16; -- IVA 16%
ALTER TABLE region ADD COLUMN IF NOT EXISTS tax_code VARCHAR(10) DEFAULT 'IVA';

-- ================================================================
-- CUSTOM TABLES FOR REPARAGYMSTORE
-- ================================================================

-- Brand management for gym equipment manufacturers
CREATE TABLE IF NOT EXISTS brand (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    logo_url VARCHAR(500),
    description TEXT,
    spanish_description TEXT,
    website_url VARCHAR(500),
    country VARCHAR(3) DEFAULT 'US',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Machine type taxonomy for equipment categorization
CREATE TABLE IF NOT EXISTS machine_type (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    spanish_name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    parent_id UUID REFERENCES machine_type(id),
    description TEXT,
    spanish_description TEXT,
    icon_name VARCHAR(50), -- For UI icons
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT now()
);

-- Product installation and maintenance guides
CREATE TABLE IF NOT EXISTS product_guide (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES product(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    spanish_title VARCHAR(255),
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(10) DEFAULT 'pdf',
    file_size_kb INTEGER,
    language VARCHAR(5) DEFAULT 'es',
    guide_type VARCHAR(20) DEFAULT 'installation', -- installation, maintenance, troubleshooting
    version VARCHAR(20) DEFAULT '1.0',
    download_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- WhatsApp orders tracking and management
CREATE TABLE IF NOT EXISTS whatsapp_order (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100),
    customer_id UUID REFERENCES customer(id),
    product_requests TEXT NOT NULL,
    order_id UUID REFERENCES "order"(id),
    status VARCHAR(20) DEFAULT 'pending',
    agent_id VARCHAR(100),
    agent_notes TEXT,
    conversation_id VARCHAR(255),
    total_estimate DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'MXN',
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- WhatsApp conversation management
CREATE TABLE IF NOT EXISTS whatsapp_conversation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_phone VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100),
    customer_id UUID REFERENCES customer(id),
    state VARCHAR(50) DEFAULT 'initial', -- initial, product_selection, collecting_info, order_confirmation, completed
    assigned_agent VARCHAR(100),
    order_id UUID REFERENCES "order"(id),
    last_message_at TIMESTAMP DEFAULT now(),
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE(customer_phone, DATE(created_at))
);

-- WhatsApp message log for audit and analysis
CREATE TABLE IF NOT EXISTS whatsapp_message (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID REFERENCES whatsapp_conversation(id) ON DELETE CASCADE,
    direction VARCHAR(10) NOT NULL, -- 'inbound' or 'outbound'
    message_type VARCHAR(20) NOT NULL, -- 'text', 'image', 'document', 'template'
    content TEXT NOT NULL,
    media_url VARCHAR(500),
    template_name VARCHAR(100),
    timestamp TIMESTAMP DEFAULT now(),
    delivered BOOLEAN DEFAULT false,
    read BOOLEAN DEFAULT false,
    whatsapp_message_id VARCHAR(255),
    error_message TEXT
);

-- Mexican shipping zones for accurate rate calculation
CREATE TABLE IF NOT EXISTS shipping_zone (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    spanish_name VARCHAR(100) NOT NULL,
    postal_codes TEXT[], -- Array of postal code patterns
    state_codes TEXT[], -- Mexican state codes (CDMX, JAL, NL, etc.)
    carriers TEXT[], -- Available carriers for this zone
    base_rate DECIMAL(8,2),
    same_day_available BOOLEAN DEFAULT false,
    express_available BOOLEAN DEFAULT true,
    standard_delivery_days INTEGER DEFAULT 7,
    express_delivery_days INTEGER DEFAULT 3,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT now()
);

-- Email verification tokens for account security
CREATE TABLE IF NOT EXISTS email_verification_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customer(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used_at TIMESTAMP,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT now()
);

-- Refresh tokens for JWT session management
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customer(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    device_info JSONB,
    ip_address INET,
    last_used_at TIMESTAMP DEFAULT now(),
    created_at TIMESTAMP DEFAULT now()
);

-- Password reset tokens
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customer(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used_at TIMESTAMP,
    ip_address INET,
    created_at TIMESTAMP DEFAULT now()
);

-- Search analytics for optimization
CREATE TABLE IF NOT EXISTS search_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    query TEXT NOT NULL,
    results_count INTEGER,
    clicked_product_id UUID REFERENCES product(id),
    customer_id UUID REFERENCES customer(id),
    session_id VARCHAR(255),
    ip_address INET,
    user_agent TEXT,
    response_time_ms INTEGER,
    filters_used JSONB,
    search_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT now()
);

-- Order analytics for business intelligence
CREATE TABLE IF NOT EXISTS order_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES "order"(id) ON DELETE CASCADE,
    customer_id UUID REFERENCES customer(id),
    acquisition_channel VARCHAR(50), -- web, whatsapp, phone, referral
    device_type VARCHAR(20), -- mobile, desktop, tablet
    conversion_time_minutes INTEGER, -- Time from first visit to order
    cart_abandonment_count INTEGER DEFAULT 0,
    payment_method VARCHAR(50),
    shipping_method VARCHAR(50),
    order_source VARCHAR(50), -- direct, search, social, etc.
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(100),
    created_at TIMESTAMP DEFAULT now()
);

-- Customer support tickets
CREATE TABLE IF NOT EXISTS support_tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id UUID REFERENCES customer(id),
    order_id UUID REFERENCES "order"(id),
    whatsapp_conversation_id UUID REFERENCES whatsapp_conversation(id),
    category VARCHAR(50) NOT NULL, -- order_issue, product_question, technical_support, etc.
    priority VARCHAR(20) DEFAULT 'medium', -- low, medium, high, urgent
    status VARCHAR(20) DEFAULT 'open', -- open, in_progress, resolved, closed
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    resolution TEXT,
    assigned_agent VARCHAR(100),
    first_response_at TIMESTAMP,
    resolved_at TIMESTAMP,
    customer_rating INTEGER CHECK (customer_rating >= 1 AND customer_rating <= 5),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- ================================================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- ================================================================

-- Customer table indexes
CREATE INDEX IF NOT EXISTS idx_customer_email_verified ON customer(email) WHERE email_verified = true;
CREATE INDEX IF NOT EXISTS idx_customer_phone ON customer(phone) WHERE phone IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_customer_company ON customer(company_name);
CREATE INDEX IF NOT EXISTS idx_customer_last_login ON customer(last_login_at);

-- Product search optimization
CREATE INDEX IF NOT EXISTS idx_product_search ON product USING gin(to_tsvector('spanish', COALESCE(spanish_title, title) || ' ' || COALESCE(spanish_description, description)));
CREATE INDEX IF NOT EXISTS idx_product_brand ON product(brand_id) WHERE brand_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_product_machine_type ON product(machine_type_id) WHERE machine_type_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_product_compatibility ON product USING gin(compatibility_tags);
CREATE INDEX IF NOT EXISTS idx_product_active ON product(status) WHERE status = 'published';

-- Product variant indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_variant_sku ON product_variant(sku) WHERE sku IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_variant_barcode ON product_variant(sku_barcode) WHERE sku_barcode IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_variant_inventory ON product_variant(inventory_quantity);
CREATE INDEX IF NOT EXISTS idx_variant_price ON product_variant(price_amount);

-- Order performance indexes
CREATE INDEX IF NOT EXISTS idx_order_status_date ON "order"(status, created_at);
CREATE INDEX IF NOT EXISTS idx_order_customer_date ON "order"(customer_id, created_at);
CREATE INDEX IF NOT EXISTS idx_order_region ON "order"(region_id);

-- WhatsApp indexes
CREATE INDEX IF NOT EXISTS idx_whatsapp_order_status ON whatsapp_order(status, created_at);
CREATE INDEX IF NOT EXISTS idx_whatsapp_order_phone ON whatsapp_order(phone_number);
CREATE INDEX IF NOT EXISTS idx_whatsapp_conversation_phone ON whatsapp_conversation(customer_phone);
CREATE INDEX IF NOT EXISTS idx_whatsapp_conversation_state ON whatsapp_conversation(state, last_message_at);
CREATE INDEX IF NOT EXISTS idx_whatsapp_message_conversation ON whatsapp_message(conversation_id, timestamp);

-- Analytics indexes
CREATE INDEX IF NOT EXISTS idx_search_analytics_date ON search_analytics(search_date);
CREATE INDEX IF NOT EXISTS idx_search_analytics_query ON search_analytics USING gin(query gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_order_analytics_channel ON order_analytics(acquisition_channel, created_at);

-- Shipping zone indexes
CREATE INDEX IF NOT EXISTS idx_shipping_zone_postal ON shipping_zone USING gin(postal_codes);
CREATE INDEX IF NOT EXISTS idx_shipping_zone_states ON shipping_zone USING gin(state_codes);

-- Support ticket indexes
CREATE INDEX IF NOT EXISTS idx_support_tickets_status ON support_tickets(status, created_at);
CREATE INDEX IF NOT EXISTS idx_support_tickets_customer ON support_tickets(customer_id, created_at);
CREATE INDEX IF NOT EXISTS idx_support_tickets_category ON support_tickets(category, priority);

-- ================================================================
-- TRIGGERS FOR AUTOMATION
-- ================================================================

-- Update timestamps trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply timestamp triggers
CREATE TRIGGER update_brand_updated_at BEFORE UPDATE ON brand
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_product_guide_updated_at BEFORE UPDATE ON product_guide
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_whatsapp_order_updated_at BEFORE UPDATE ON whatsapp_order
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_support_tickets_updated_at BEFORE UPDATE ON support_tickets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================================
-- VIEWS FOR COMMON QUERIES
-- ================================================================

-- Product search view with all necessary fields
CREATE OR REPLACE VIEW product_search_view AS
SELECT 
    p.id,
    p.title,
    p.spanish_title,
    p.description,
    p.spanish_description,
    p.handle,
    p.thumbnail,
    p.status,
    p.created_at,
    p.updated_at,
    b.name as brand_name,
    b.slug as brand_slug,
    mt.name as machine_type_name,
    mt.spanish_name as machine_type_spanish,
    mt.slug as machine_type_slug,
    p.compatibility_tags,
    p.weight_kg,
    p.dimensions_cm,
    p.technical_specs,
    -- Aggregate variant information
    (SELECT MIN(pv.price_amount) FROM product_variant pv WHERE pv.product_id = p.id) as min_price,
    (SELECT MAX(pv.price_amount) FROM product_variant pv WHERE pv.product_id = p.id) as max_price,
    (SELECT SUM(pv.inventory_quantity) FROM product_variant pv WHERE pv.product_id = p.id) as total_inventory,
    (SELECT COUNT(*) FROM product_guide pg WHERE pg.product_id = p.id AND pg.is_active = true) as guide_count
FROM product p
LEFT JOIN brand b ON p.brand_id = b.id
LEFT JOIN machine_type mt ON p.machine_type_id = mt.id
WHERE p.status = 'published';

-- Customer order summary view
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
    c.id as customer_id,
    c.email,
    c.first_name,
    c.last_name,
    c.company_name,
    c.phone,
    COUNT(o.id) as total_orders,
    SUM(o.total) as total_spent,
    MAX(o.created_at) as last_order_date,
    AVG(o.total) as average_order_value,
    COUNT(CASE WHEN o.created_at >= NOW() - INTERVAL '30 days' THEN 1 END) as orders_last_30_days
FROM customer c
LEFT JOIN "order" o ON c.id = o.customer_id
WHERE c.email_verified = true
GROUP BY c.id, c.email, c.first_name, c.last_name, c.company_name, c.phone;

-- WhatsApp conversation summary
CREATE OR REPLACE VIEW whatsapp_conversation_summary AS
SELECT 
    wc.id,
    wc.customer_phone,
    wc.customer_name,
    wc.state,
    wc.assigned_agent,
    wc.created_at,
    wc.last_message_at,
    COUNT(wm.id) as message_count,
    COUNT(CASE WHEN wm.direction = 'inbound' THEN 1 END) as inbound_messages,
    COUNT(CASE WHEN wm.direction = 'outbound' THEN 1 END) as outbound_messages,
    wo.order_id,
    wo.status as order_status,
    wo.total_estimate
FROM whatsapp_conversation wc
LEFT JOIN whatsapp_message wm ON wc.id = wm.conversation_id
LEFT JOIN whatsapp_order wo ON wc.id = wo.conversation_id
GROUP BY wc.id, wc.customer_phone, wc.customer_name, wc.state, wc.assigned_agent, 
         wc.created_at, wc.last_message_at, wo.order_id, wo.status, wo.total_estimate;

-- ================================================================
-- SEED DATA FOR MEXICAN MARKET
-- ================================================================

-- Insert Mexican shipping zones
INSERT INTO shipping_zone (name, spanish_name, state_codes, postal_codes, carriers, base_rate, same_day_available, express_delivery_days, standard_delivery_days) VALUES
('Zona Metropolitana', 'Zona Metropolitana', ARRAY['CDMX', 'MEX'], ARRAY['0%', '1%', '50%', '51%', '52%', '53%', '54%', '55%', '56%', '57%'], ARRAY['fedex', 'ups', 'estafeta'], 120.00, true, 1, 3),
('Norte', 'Norte', ARRAY['NL', 'CHH', 'COAH', 'TAMPS', 'SON'], ARRAY['2%', '3%', '6%', '8%', '25%', '26%', '27%', '28%', '83%', '84%', '85%', '86%', '87%'], ARRAY['fedex', 'ups'], 180.00, false, 2, 5),
('Occidente', 'Occidente', ARRAY['JAL', 'NAY', 'AGS', 'GTO', 'MICH'], ARRAY['20%', '44%', '45%', '46%', '47%', '58%', '59%', '60%', '61%', '63%'], ARRAY['fedex', 'ups', 'estafeta'], 160.00, false, 2, 5),
('Sur', 'Sur', ARRAY['OAX', 'CHIS', 'GRO', 'VER', 'TAB'], ARRAY['29%', '30%', '39%', '68%', '70%', '86%', '91%', '92%', '93%', '94%', '95%', '96%'], ARRAY['estafeta', 'ups'], 220.00, false, 3, 7),
('Sureste', 'Sureste', ARRAY['CAM', 'QROO', 'YUC'], ARRAY['24%', '77%', '97%', '98%'], ARRAY['estafeta', 'ups'], 250.00, false, 3, 7);

-- Insert common machine types
INSERT INTO machine_type (name, spanish_name, slug, description, spanish_description, sort_order) VALUES
('Cardiovascular Equipment', 'Equipo Cardiovascular', 'cardiovascular', 'Treadmills, ellipticals, bikes, and cardio machines', 'Caminadoras, elípticas, bicicletas y máquinas de cardio', 1),
('Strength Equipment', 'Equipo de Fuerza', 'fuerza', 'Weight machines, free weights, and strength training equipment', 'Máquinas de pesas, pesas libres y equipo de entrenamiento de fuerza', 2),
('Functional Training', 'Entrenamiento Funcional', 'funcional', 'Functional training and cross-training equipment', 'Equipo de entrenamiento funcional y cross-training', 3);

-- Insert subcategories for cardiovascular
INSERT INTO machine_type (name, spanish_name, slug, parent_id, description, spanish_description, sort_order) VALUES
('Treadmills', 'Caminadoras', 'caminadoras', (SELECT id FROM machine_type WHERE slug = 'cardiovascular'), 'Treadmills and running machines', 'Caminadoras y máquinas para correr', 1),
('Ellipticals', 'Elípticas', 'elipticas', (SELECT id FROM machine_type WHERE slug = 'cardiovascular'), 'Elliptical trainers and cross trainers', 'Máquinas elípticas y cross trainers', 2),
('Exercise Bikes', 'Bicicletas de Ejercicio', 'bicicletas', (SELECT id FROM machine_type WHERE slug = 'cardiovascular'), 'Stationary bikes and spinning bikes', 'Bicicletas estáticas y de spinning', 3);

-- Insert major fitness equipment brands
INSERT INTO brand (name, slug, description, spanish_description, website_url, country) VALUES
('Life Fitness', 'life-fitness', 'Leading manufacturer of fitness equipment', 'Fabricante líder de equipo de fitness', 'https://www.lifefitness.com', 'US'),
('Technogym', 'technogym', 'Italian fitness equipment manufacturer', 'Fabricante italiano de equipo de fitness', 'https://www.technogym.com', 'IT'),
('Precor', 'precor', 'Premium fitness equipment brand', 'Marca premium de equipo de fitness', 'https://www.precor.com', 'US'),
('Matrix', 'matrix', 'Commercial fitness equipment', 'Equipo de fitness comercial', 'https://www.matrixfitness.com', 'US'),
('Star Trac', 'star-trac', 'Commercial cardio and strength equipment', 'Equipo comercial de cardio y fuerza', 'https://www.startrac.com', 'US');

-- ================================================================
-- DATABASE FUNCTIONS FOR BUSINESS LOGIC
-- ================================================================

-- Function to calculate shipping cost based on zone and weight
CREATE OR REPLACE FUNCTION calculate_shipping_cost(
    postal_code VARCHAR(5),
    weight_kg DECIMAL,
    shipping_type VARCHAR(20) DEFAULT 'standard'
) RETURNS DECIMAL AS $$
DECLARE
    zone_rate DECIMAL;
    weight_multiplier DECIMAL;
    final_cost DECIMAL;
BEGIN
    -- Find the shipping zone for the postal code
    SELECT base_rate INTO zone_rate
    FROM shipping_zone sz
    WHERE postal_code LIKE ANY(sz.postal_codes)
    AND is_active = true
    LIMIT 1;
    
    -- If no zone found, use default rate
    IF zone_rate IS NULL THEN
        zone_rate := 200.00;
    END IF;
    
    -- Calculate weight multiplier (base rate for first 5kg, then additional cost)
    IF weight_kg <= 5 THEN
        weight_multiplier := 1.0;
    ELSE
        weight_multiplier := 1.0 + ((weight_kg - 5) * 0.2); -- 20% additional per kg over 5kg
    END IF;
    
    -- Apply shipping type multiplier
    CASE shipping_type
        WHEN 'express' THEN final_cost := zone_rate * weight_multiplier * 1.5;
        WHEN 'same_day' THEN final_cost := zone_rate * weight_multiplier * 2.5;
        ELSE final_cost := zone_rate * weight_multiplier;
    END CASE;
    
    RETURN ROUND(final_cost, 2);
END;
$$ LANGUAGE plpgsql;

-- Function to get product search suggestions
CREATE OR REPLACE FUNCTION get_search_suggestions(search_term VARCHAR(100))
RETURNS TABLE(suggestion VARCHAR(255), type VARCHAR(20)) AS $$
BEGIN
    RETURN QUERY
    -- Product titles
    SELECT DISTINCT p.spanish_title as suggestion, 'product'::VARCHAR(20) as type
    FROM product p
    WHERE p.spanish_title ILIKE '%' || search_term || '%'
    AND p.status = 'published'
    LIMIT 5
    
    UNION ALL
    
    -- Brand names
    SELECT DISTINCT b.name as suggestion, 'brand'::VARCHAR(20) as type
    FROM brand b
    WHERE b.name ILIKE '%' || search_term || '%'
    AND b.is_active = true
    LIMIT 3
    
    UNION ALL
    
    -- Machine types
    SELECT DISTINCT mt.spanish_name as suggestion, 'category'::VARCHAR(20) as type
    FROM machine_type mt
    WHERE mt.spanish_name ILIKE '%' || search_term || '%'
    AND mt.is_active = true
    LIMIT 3;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- COMMENTS FOR DOCUMENTATION
-- ================================================================

COMMENT ON TABLE customer IS 'Enhanced customer table with Mexican B2B market requirements including company information and verification status';
COMMENT ON TABLE product IS 'Enhanced product table with Spanish translations, technical specifications, and shipping information';
COMMENT ON TABLE brand IS 'Gym equipment manufacturer brands with localization support';
COMMENT ON TABLE machine_type IS 'Hierarchical equipment categorization for easy navigation';
COMMENT ON TABLE product_guide IS 'Installation and maintenance guides for products in multiple languages';
COMMENT ON TABLE whatsapp_order IS 'Orders initiated through WhatsApp Business API integration';
COMMENT ON TABLE whatsapp_conversation IS 'Customer service conversations via WhatsApp';
COMMENT ON TABLE shipping_zone IS 'Mexican shipping zones with carrier availability and pricing';
COMMENT ON TABLE search_analytics IS 'Search behavior tracking for optimization';
COMMENT ON TABLE order_analytics IS 'Order acquisition and conversion tracking';
COMMENT ON TABLE support_tickets IS 'Customer support ticket management system';

-- Grant permissions to application user
-- GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO reparagym_app;
-- GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO reparagym_app;

-- Final schema validation
SELECT 'ReparagymStore schema setup completed successfully' as status;