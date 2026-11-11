-- Migration 001: Initial schema for LinkPilot AI

-- Habilitar extensão para geração de UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Tabela de Tendências e Ideias (Coletadas pelo Research Agent)
CREATE TABLE IF NOT EXISTS content_trends (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic VARCHAR(255) NOT NULL,
    summary TEXT,
    source_url TEXT,
    relevance_score NUMERIC(3, 2) DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Publicações (Fluxo editorial: rascunho -> revisado -> aprovado -> publicado)
CREATE TABLE IF NOT EXISTS publications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trend_id UUID REFERENCES content_trends(id) ON DELETE SET NULL,
    title VARCHAR(255),
    content TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'review_pending', 'reviewed', 'approved', 'rejected', 'published')),
    scheduled_for TIMESTAMP WITH TIME ZONE,
    published_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabela de Logs dos Agentes (Auditoria e rastreamento das etapas)
CREATE TABLE IF NOT EXISTS agent_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    publication_id UUID REFERENCES publications(id) ON DELETE CASCADE,
    agent_name VARCHAR(100) NOT NULL, -- 'Research Agent', 'Content Strategist', 'Copywriter Agent', etc.
    action VARCHAR(100) NOT NULL,
    input_payload JSONB,
    output_payload JSONB,
    status VARCHAR(50) DEFAULT 'success',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

